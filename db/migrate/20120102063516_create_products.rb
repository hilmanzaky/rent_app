class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.string :description
      t.decimal :price
      t.decimal :rent_price
      t.integer :stock

      t.timestamps
    end
  end
end
