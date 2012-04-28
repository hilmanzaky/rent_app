class RentedProduct < ActiveRecord::Base
  belongs_to :ordered_product
  has_many :returned_products
  belongs_to :order
  belongs_to :product
end
