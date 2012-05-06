class AddOriSubTotalToOrderedProducts < ActiveRecord::Migration
  def change
    add_column :ordered_products, :ori_sub_total, :float
  end
end
