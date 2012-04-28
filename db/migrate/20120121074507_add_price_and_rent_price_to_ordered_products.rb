class AddPriceAndRentPriceToOrderedProducts < ActiveRecord::Migration
  def change
    add_column :ordered_products, :price, :decimal
    add_column :ordered_products, :rent_price, :decimal
  end
end
