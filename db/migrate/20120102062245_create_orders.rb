class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :customer
      t.string :address
      t.string :phone
      t.date :delivery_date
      t.date :usage_date
      t.integer :duration_in_days
      t.decimal :total_price_per_day
      t.decimal :total_price
      t.integer :payment_status
      t.integer :user_id

      t.timestamps
    end
  end
end
