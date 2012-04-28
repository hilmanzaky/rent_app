class CreateOrderedProducts < ActiveRecord::Migration
  def change
    create_table :ordered_products do |t|
      t.integer :order_id
      t.integer :product_id
      t.string :description
      t.decimal :sub_total
      t.integer :qty

      t.timestamps
    end
  end
end
