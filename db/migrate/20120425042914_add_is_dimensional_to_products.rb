class AddIsDimensionalToProducts < ActiveRecord::Migration
  def change
    add_column :products, :is_dimensional, :boolean
  end
end
