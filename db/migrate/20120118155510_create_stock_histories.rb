class CreateStockHistories < ActiveRecord::Migration
  def change
    create_table :stock_histories do |t|
      t.integer :old
      t.integer :new
      t.integer :product_stock_id
      t.string :description

      t.timestamps
    end
  end
end
