class ProductChild < ActiveRecord::Base
  set_table_name "products"

  has_many :product_parents, :through => :product_packages, :foreign_key => 'child_id'
  has_many :product_packages, :foreign_key => 'child_id'
end