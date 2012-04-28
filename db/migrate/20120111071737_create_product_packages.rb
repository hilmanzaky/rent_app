class CreateProductPackages < ActiveRecord::Migration
  def change
    create_table :product_packages do |t|
      t.integer :parent_id
      t.integer :child_id
      t.integer :reduced_stocks

      t.timestamps
    end
  end
end
