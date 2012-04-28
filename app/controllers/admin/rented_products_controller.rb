class Admin::RentedProductsController < ApplicationController
  before_filter :admin_required

  def index
    @order = Order.find(params[:order_id])
    @rented_products = @order.rented_products.joins("LEFT JOIN products ON rented_products.product_id = products.id")
    @returned_products = Array.new(@rented_products.length) { RentedProduct.new }
  end

#  def new
#    @order = Order.find(params[:order_id])
#    @ordered_products = @order.ordered_products.
#      joins('LEFT JOIN products p ON ordered_products.product_id = p.id').
#      select('ordered_products.id, qty, name, ordered_products.rent_price, sub_total, ordered_products.description, is_package, product_id')
#    @return_product = ReturnProduct.new
#  end

  def create

    
    #    ReturnProduct.triggered_save(params[:return_product])
    #
    #    respond_to do |format|
    #      format.html { redirect_to admin_orders_path }
    #    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

end
