class CreateRentedProducts < ActiveRecord::Migration
  def change
    create_table :rented_products do |t|
      t.integer :ordered_product_id
      t.integer :order_id
      t.integer :product_id
      t.integer :return_qty, :default => 0
      t.integer :rented_qty

      t.timestamps
    end
  end
end
