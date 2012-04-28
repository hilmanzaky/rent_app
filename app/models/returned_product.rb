class ReturnedProduct < ActiveRecord::Base
  belongs_to :rented_product

  after_save do |rp|
    rented_product = rp.rented_product
    rented_product.update_attribute(:return_qty, rented_product.return_qty + rp.return_qty)
  end
end
