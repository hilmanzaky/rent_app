class Admin::PaymentsController < ApplicationController

  def index
    @order = Order.find(params[:order_id])
    @ordered_products = @order.ordered_products
    @payments = @order.payments.order('created_at ASC')
  end

  def new
    @order = Order.find(params[:order_id])
    @payment = @order.payments.build
    @payment.remains = @order.total_price - @order.payments.sum(:amount)

    render layout: false
  end

  def create
    @payment = Payment.new(params[:payment])

    respond_to do |format|
      if @payment.save
        format.html { redirect_to admin_order_path(params[:payment][:order_id]), notice: 'Data pembayaran telah tersimpan.' }
      else
        flash[:error] = 'Data pembayaran gagal disimpan'
        format.html { redirect_to admin_order_path(@payment.order_id) }
      end
    end
  end

  def edit
    @payment = Payment.find(params[:id])
    @payment.remains = @payment.order.total_price - @payment.order.payments.sum(:amount)
    
    render layout: false
  end

  def update
    @payment = Payment.find(params[:id])

    respond_to do |format|
      if @payment.update_attributes(params[:payment])
        format.html { redirect_to admin_order_path(params[:payment][:order_id]), notice: 'Data pembayaran telah diubah.' }
      else
        flash[:error] = 'Data pembayaran gagal diubah'
        format.html { redirect_to admin_order_path(@payment.order_id) }
      end
    end
  end

  def destroy
    @payment = Payment.find(params[:id])
    order = @payment.order_id
    if @payment.destroy
      flash[:notice] = 'Data pembayaran telah dihapus'
    else
      flash[:error] = 'Data tidak dapat dihapus'
    end
    respond_to do |format|
      format.html { redirect_to admin_order_payments_path(order) }
    end
  end

end
