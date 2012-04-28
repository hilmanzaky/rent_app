class ProductStock < ActiveRecord::Base
  def update_stock_history(product_stock, description)
      stock_history = StockHistory.new(:old => self.stock,
                                       :new => product_stock[:stock],
                                       :product_stock_id => self.id,
                                       :description => description)
      stock_history.save
  end

  def triggered_save
    self.save
    product = self.product
    product.update_attribute(:stock, product.stock + self.stock)
#    update_stocks(product.parents)
  end

  def triggered_update_attributes(product_stock_array)
    old_stock = self.stock
    self.update_attributes(product_stock_array)
    gap = old_stock - self.stock
    product = self.product
    product.update_attribute(:stock, product.stock - gap)
#    update_stocks(product.parents)
  end

#  def self.update_stocks(parents)
#    parents.each do |parent|
#      min = ProductPackage.where(:parent_id => parent.parent_id).joins('LEFT JOIN products p ON product_packages.child_id = p.id').minimum('stock / product_packages.reduced_stocks')
#      parent.parent.update_attribute(:stock, min)
#    end
#  end

  belongs_to :product
  has_many :stock_histories
  has_many :rented_products

end

