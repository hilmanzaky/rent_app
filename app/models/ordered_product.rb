class OrderedProduct < ActiveRecord::Base
  #  before_destroy do |ordered_product|
  #    product = ordered_product.product
  #    product.update_attribute(:stock, product.stock + ordered_product.qty)
  #  end
  
  belongs_to :order
  belongs_to :product
  has_many :rented_products, :dependent => :destroy

  attr_accessor :flash_error
  #  def save_or_update(ordered_product)
  #    unless self.id.blank? # untuk update data
  #      self.update_attributes(ordered_product)
  #    else  # untuk data baru
  #      self.save
  #    end
  #  end

  def triggered_destroy
    product = self.product
    unless product.is_dimensional?
      if product.is_package?
        product.childs.each do |p|

          total_reduced_stocks = p.reduced_stocks * self.qty
          p.child.update_attribute(:stock, p.child.stock + total_reduced_stocks)

          #        ProductStock.update_stocks(p.child.parents)
        end
      else
        product.update_attribute(:stock, product.stock + self.qty)
      end
    end
    self.destroy
  end

  def self.get_new_ordered_products(user_id)
    self.where("user_id = ? AND order_id IS NULL", user_id)
  end

  def update_ordered_product(temp_ordered_product)
    self.update_attributes(temp_ordered_product)
    if self.order_id.blank?
      #      return "admin_products_path"
      return "/admin/products"
    else
      order = self.order
      temp_order = {}
      temp_order[:total_price_per_day] = order.ordered_products.sum(:sub_total)
      temp_order[:total_price] = temp_order[:total_price_per_day] * order.duration_in_days + order.delivery_cost
      order.update_attributes(temp_order)
      #      return "admin_order_edit_detail_path(#{self.order_id})"
      return "/admin/orders/#{self.order_id}/edit_detail"
    end
  end

  def complex_triggered_update(temp_ordered_product, rp)
    success = true
    product = self.product
    err_msg = []
    rented_products = []
    return_url = ""
    OrderedProduct.transaction do
      if product.is_package? # if package then of course take a loop as many products contained in it
        products = product.childs.joins("LEFT JOIN products p ON product_packages.child_id = p.id
                                         LEFT JOIN (SELECT product_id, rented_qty
                                                    FROM rented_products
                                                    WHERE ordered_product_id = #{self.id}) rp ON product_packages.child_id = rp.product_id").
          select('product_packages.id, child_id, reduced_stocks, p.name, stock, rented_qty')
        products.each do |p|
          #          p "1 #{p.rented_qty}"
          if product.is_dimensional?
            if p.rented_qty.blank?
              total_reduced_stocks = p.reduced_stocks * rp["#{p.child_id}"]["rented_qty"].to_i
            else
              total_reduced_stocks = p.rented_qty - (p.reduced_stocks * rp["#{p.child_id}"]["rented_qty"].to_i)
            end
          else
            total_reduced_stocks = p.reduced_stocks * (self.qty - temp_ordered_product[:qty].to_i)
          end
          unless (product.is_dimensional? and total_reduced_stocks == 0)
            if p.stock < -(total_reduced_stocks) # apabila stok barang tidak mencukupi
              success = false
              err_msg << "Stok #{p.name} tidak mencukupi"
            else
              if success
                if p.rented_qty.blank?
                  p.child.update_attribute(:stock, p.stock - total_reduced_stocks)
                  rented_products << { :product_id => p.child_id,
                    :order_id => self.order_id,
                    :rented_qty => total_reduced_stocks,
                    :ordered_product_id => self.id
                  }
                else
                  rented_product = RentedProduct.where("ordered_product_id = ? AND product_id = ?",self.id, p.child_id).first
                  rented_product.update_attribute(:rented_qty, rented_product.rented_qty - total_reduced_stocks)
                  p.child.update_attribute(:stock, p.stock + total_reduced_stocks) # stok sekarang - total qty lama + total qty baru
                end
              end
            end
          end
        end

        if success
          RentedProduct.create(rented_products)
          if product.is_dimensional?
            temp_ordered_product[:sub_total] = self.rent_price * temp_ordered_product[:width].to_f * temp_ordered_product[:height].to_f
          else
            temp_ordered_product[:sub_total] = self.rent_price * temp_ordered_product[:qty].to_i
          end
          return_url = self.update_ordered_product(temp_ordered_product)
        else
          return_url = self.generate_error_msg(err_msg)
          raise ActiveRecord::Rollback
        end
      else
        unless product.stock < temp_ordered_product[:qty].to_i
          product.update_attribute(:stock, product.stock + (self.qty - temp_ordered_product[:qty].to_i))
          temp_ordered_product[:sub_total] = self.rent_price * temp_ordered_product[:qty].to_i
          return_url = self.update_ordered_product(temp_ordered_product)
          self.rented_products.first.update_attribute(:rented_qty, self.qty)
        else
          return_url = self.generate_error_msg(err_msg)
          raise ActiveRecord::Rollback
        end
      end
    end

    return return_url
  end

  # coba save dengan metode baru yang lebih efisien
  def complex_triggered_save(user_id, rp)
    success = true
    product = self.product
    err_msg = []
    rented_products = []
    return_url = ""
    OrderedProduct.transaction do
      if product.is_package? # if package then of course take a loop as many products contained in it
        products = product.childs.joins('LEFT JOIN products p ON product_packages.child_id = p.id').
          select('product_packages.id, child_id, reduced_stocks, p.name, stock')
        products.each do |p|
          if product.is_dimensional?
            total_reduced_stocks = p.reduced_stocks * rp["#{p.child_id}"]["rented_qty"].to_i
          else
            total_reduced_stocks = p.reduced_stocks * self.qty # menghitung total qty barang yang akan berkurang
          end
          unless (product.is_dimensional? and total_reduced_stocks == 0)
            if p.stock < total_reduced_stocks # apabila stok barang tidak mencukupi
              success = false
              err_msg << "Stok #{p.name} tidak mencukupi"
            else
              p.child.update_attribute(:stock, p.stock - total_reduced_stocks) if success
              rented_products << { :product_id => p.child_id,
                :order_id => self.order_id,
                :rented_qty => total_reduced_stocks,
              }
            end
          end
        end

        if success
          return_url = self.save_ordered_product(product, user_id)
          rented_products.each { |r| r[:ordered_product_id] = self.id }
          RentedProduct.create(rented_products)
        else
          return_url = self.generate_error_msg(err_msg)
          raise ActiveRecord::Rollback
        end
      else
        unless product.stock < self.qty
          product.update_attribute(:stock, product.stock - self.qty)
          return_url = self.save_ordered_product(product, user_id)
          rented_product = RentedProduct.new({ :product_id => self.product_id,
              :ordered_product_id => self.id,
              :order_id => self.order_id,
              :rented_qty => self.qty
            })
          rented_product.save
        else
          return_url = self.generate_error_msg(err_msg)
          raise ActiveRecord::Rollback
        end
      end
    end
    return return_url
  end
  
  def generate_error_msg(err_msg)
    self.flash_error = "Melebihi stok"
    self.flash_error << "<ul><li>#{err_msg.join("</li><li>")}</li></ul>" if err_msg.length > 0

    if self.order_id.blank?
      #      return "admin_products_path"
      return "/admin/products"
    else
      #      return "admin_order_edit_detail_path"
      return "/admin/orders/#{self.order_id}/edit_detail"
    end
  end

  def save_ordered_product(product, user_id)
    self.user_id = user_id
    self.price = product.price
    self.rent_price = product.rent_price
    if product.is_dimensional?
      self.sub_total = self.rent_price * self.width * self.height
    else
      self.sub_total = self.rent_price * self.qty
    end
    self.save
    if self.order_id.blank?
      #      return "admin_products_path"
      return "/admin/products"
    else
      order = self.order
      temp_order = {}
      temp_order[:total_price_per_day] = order.ordered_products.sum(:sub_total)
      temp_order[:total_price] = temp_order[:total_price_per_day] * order.duration_in_days + order.delivery_cost
      order.update_attributes(temp_order)
      #      return "admin_order_edit_detail_path(#{self.order_id})"
      return "/admin/orders/#{self.order_id}/edit_detail"
    end
  end


  
  
end
