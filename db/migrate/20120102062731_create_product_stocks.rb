class CreateProductStocks < ActiveRecord::Migration
  def change
    create_table :product_stocks do |t|
      t.integer :stock
      t.integer :product_id

      t.timestamps
    end
  end
end
