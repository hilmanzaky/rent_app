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

  #  def self.stocks_in(date)
  #    find_by_sql("SELECT a.product_id as id, name, description, price, rent_price, is_package, is_rented, stock_out, is_dimensional, stock, rented_qty, (stock - rented_qty) as remain
  #                  FROM (SELECT product_id, name, description, price, rent_price, is_package, is_rented, stock_out, is_dimensional, SUM(a.stock) as stock
  #                        FROM product_stocks a
  #                             LEFT JOIN products b ON a.product_id = b.id
  #                        GROUP BY product_id) a
  #                       LEFT JOIN (SELECT product_id, SUM(rented_qty) as rented_qty
  #                            FROM rented_products a
  #                            LEFT JOIN orders b ON a.order_id = b.id
  #                            WHERE b.delivery_date = '#{date}'
  #                            GROUP BY product_id) b ON a.product_id = b.product_id#")
  #  end

  scope :stocks, joins("LEFT JOIN product_stocks b ON products.id = b.product_id").
    group("b.product_id").
    select("products.id as id, name, description, price, rent_price, is_package, is_rented, stock_out, is_dimensional, SUM(b.stock) as stock")
  scope :stocks_at, lambda { |date|
    stocks.joins("LEFT JOIN (SELECT product_id, SUM(rented_qty) as rented_qty
                             FROM rented_products a
                             LEFT JOIN orders b ON a.order_id = b.id
                             WHERE '#{date}' BETWEEN b.delivery_date AND DATE_ADD(b.usage_date, INTERVAL (b.duration_in_days - 1) DAY)
                             GROUP BY product_id) c ON b.product_id = c.product_id").
      select("COALESCE(rented_qty, 0) as rented_qty, (SUM(b.stock) - COALESCE(rented_qty, 0)) as remain")
  }
#  scope :stocks_at, lambda { |date|
#    stocks.joins("LEFT JOIN (SELECT product_id, SUM(rented_qty) as rented_qty
#                             FROM rented_products a
#                             LEFT JOIN orders b ON a.order_id = b.id
#                             WHERE b.delivery_date = '#{date}'
#                             GROUP BY product_id) c ON b.product_id = c.product_id#").
#      select("COALESCE(rented_qty, 0) as rented_qty, (SUM(b.stock) - COALESCE(rented_qty, 0)) as remain")
#  }

  def package_stock(date)
    product = Product.find_by_sql("SELECT MIN(remain) as remain
                           FROM
                           (SELECT SUM(stock) -  COALESCE(rented_qty, 0) as remain
                           FROM (SELECT child_id FROM product_packages WHERE parent_id = #{self.id}) a
                                      LEFT JOIN product_stocks b ON a.child_id = b.product_id
                                      LEFT JOIN  (SELECT product_id, SUM(rented_qty) as rented_qty
                                                         FROM rented_products a LEFT JOIN orders b ON a.order_id = b.id
                                                         WHERE '#{date}' BETWEEN b.delivery_date AND DATE_ADD(b.usage_date, INTERVAL (b.duration_in_days - 1) DAY)
                                                         GROUP BY product_id) c ON b.product_id = c.product_id
                           GROUP BY b.product_id) a")
    product.first.remain
  end

#  def available_for_package
#    Product.where("products.id = ? AND child_id IS NULL", self.id).
#            joins("LEFT JOIN (SELECT child_id
#                              FROM product_packages
#                              WHERE parent_id = #{self.id}) b ON products.id = b.child_id#")
#  end

  scope :available_for_package, lambda { |id|
    where("products.id != ? AND child_id IS NULL", id).
    joins("LEFT JOIN (SELECT child_id
                      FROM product_packages
                      WHERE parent_id = #{id}) b ON products.id = b.child_id")
  }
end
