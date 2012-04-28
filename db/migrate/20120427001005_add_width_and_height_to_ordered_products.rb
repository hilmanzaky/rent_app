class AddWidthAndHeightToOrderedProducts < ActiveRecord::Migration
  def change
    add_column :ordered_products, :width, :double
    add_column :ordered_products, :height, :double
  end
end
