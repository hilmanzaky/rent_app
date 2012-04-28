class Order < ActiveRecord::Base
  belongs_to :user
  has_many :ordered_products
  has_many :products, :through => :ordered_products
  has_many :payments
  has_many :rented_products
end