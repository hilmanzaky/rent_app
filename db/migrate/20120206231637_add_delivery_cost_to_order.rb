class AddDeliveryCostToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :delivery_cost, :decimal
  end
end
