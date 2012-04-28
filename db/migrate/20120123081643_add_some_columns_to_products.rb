class AddSomeColumnsToProducts < ActiveRecord::Migration
  def change
    # to indicate that the product is a package // menandakan bahwa produk ini adalah paket
    add_column :products, :is_package, :boolean
    # to indicate that the product is a dimensional product // menandakan bahwa produk ini adalah produk berdimensi
#    add_column :products, :is_dimensional, :boolean
    # to indicate that the product can be rented (not a part that can't be rented) // menandakan bahwa produk ini adalah produk yang dapat disewa (bukan merupakan bagian penyusun produk lainnya yang tidak dapat disewa)
    add_column :products, :is_rented, :boolean
    add_column :products, :stock_out, :integer, :default => 0
  end
end