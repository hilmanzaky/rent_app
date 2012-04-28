class CreateReturnedProducts < ActiveRecord::Migration
  def change
    create_table :returned_products do |t|
      t.integer :return_qty
      t.integer :rented_product_id

      t.timestamps
    end
  end
end
