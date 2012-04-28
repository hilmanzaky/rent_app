class ProductPackage < ActiveRecord::Base
  belongs_to :parent, :class_name => "Product", :foreign_key => "parent_id"
  belongs_to :child, :class_name => "Product", :foreign_key => "child_id"
#belongs_to :product_parent, :foreign_key => "parent_id"
#belongs_to :product_child, :foreign_key => "child_id"

  def triggered_save
    self.save
    product = Product.find(self.child_id)
    product.update_stocks
  end
end
