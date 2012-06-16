class AddIsDeliveredToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :is_delivered, :boolean
  end
end
