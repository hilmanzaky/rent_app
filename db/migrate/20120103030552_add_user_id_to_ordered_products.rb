class AddUserIdToOrderedProducts < ActiveRecord::Migration
  def change
    add_column :ordered_products, :user_id, :integer
  end
end
