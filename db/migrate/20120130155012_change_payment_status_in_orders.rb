class ChangePaymentStatusInOrders < ActiveRecord::Migration
  def change
    change_column :orders, :payment_status, :string
  end
end
