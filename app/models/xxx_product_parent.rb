class ProductParent < ActiveRecord::Base
  set_table_name "products"

  has_many :product_childs, :through => :product_packages, :foreign_key => 'parent_id'
  has_many :product_packages, :foreign_key => 'parent_id'
end