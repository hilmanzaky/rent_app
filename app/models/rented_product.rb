class RentedProduct < ActiveRecord::Base
  belongs_to :ordered_product
  has_many :returned_products
  belongs_to :order
  belongs_to :product

#  before_destroy do |record|
#    product = record.product
#    product.update_attribute(:stock, product.stock + record.rented_qty)
#  end
end
