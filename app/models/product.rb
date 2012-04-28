class Product < ActiveRecord::Base
  #hm
  has_many :product_stocks
  has_many :rented_products

  # hmt
  has_many :orders, :through => :ordered_products
  has_many :ordered_products

  has_many :products, :through => :product_packages
  has_many :parents, :class_name => 'ProductPackage', :foreign_key => 'child_id'
  has_many :childs, :class_name => 'ProductPackage', :foreign_key => 'parent_id'

  after_save :update_stocks

  def update_stocks
    parents = self.parents
    parents.each do |parent|
      min = ProductPackage.where(:parent_id => parent.parent_id).
                           joins('LEFT JOIN products p ON product_packages.child_id = p.id').
                           minimum('stock / product_packages.reduced_stocks')
      parent.parent.update_attribute(:stock, min)
    end
  end
#  after_save do |product|
#    parents = product.parents
#    parents.each do |parent|
#      min = ProductPackage.where(:parent_id => 5).joins('LEFT JOIN products p ON product_packages.child_id = p.id').select(:stock).minimum(:stock)
#      parent.parent.update_attribute(:stock, min)
#    end
#  end

  def triggered_save
    self.save
  end
  
  def triggered_update_attributes(product_array)
    self.update_attributes(product_array)
  end

  def triggered_destroy
    parents = self.parents
    parents.each do |parent|
      min = ProductPackage.where("parent_id = ? and child_id != ?", parent.parent_id, self.id).
                           joins('LEFT JOIN products p ON product_packages.child_id = p.id').
                           minimum('stock / product_packages.reduced_stocks')
      parent.parent.update_attribute(:stock, min)
      parent.destroy
    end

    self.destroy
  end

  def direct_childs
    childs.select("products.id, name, description, price, rent_price, stock, is_package, is_rented, stock_out, is_dimensional, reduced_stocks, parent_id").
        joins("LEFT JOIN products ON product_packages.child_id = products.id")

      #    where("parent_id = ?", product_id).
  end

  
end
