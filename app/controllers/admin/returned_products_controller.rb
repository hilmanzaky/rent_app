class Admin::ReturnedProductsController < ApplicationController
  before_filter :admin_required

  def index
    
  end

  def create
    msg = []
    ReturnedProduct.transaction do
      params[:rented_product].each do |rp|
        @returned_product = ReturnedProduct.new(rp)
        if !@returned_product.return_qty.blank? and (@returned_product.return_qty != 0)
          if @returned_product.save
            msg << "#{@returned_product.rented_product.product.name} telah dikembalikan sebanyak #{@returned_product.return_qty}"
          else
            raise ActiveRecord::Rollback
          end
        end
      end
    end

    rented_product = RentedProduct.find(params[:rented_product].first['rented_product_id'])

    respond_to do |format|
      format.html { redirect_to admin_order_rented_products_path(rented_product.order_id), notice: msg.join('<br/>') }
    end
  end
end
