class ChangeColumnDefaultForStockInProducts < ActiveRecord::Migration
  def change
    change_column_default(:products, :stock, 0)
  end
end
