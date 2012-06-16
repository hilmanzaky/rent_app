class Order < ActiveRecord::Base
  belongs_to :user
  has_many :ordered_products, :dependent => :destroy
  has_many :products, :through => :ordered_products
  has_many :payments, :dependent => :destroy
  has_many :rented_products


#  before_destroy do |record|
#    record.ordered_products.destroy_all # would triggered rented_products to be destroyed by ordered_product having dependent :destroy relation with rented_product
#    record.rented_products.destroy_all
#  end

end