class Admin::OrdersController < ApplicationController
  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.joins('LEFT JOIN users ON orders.user_id = users.id')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @orders }
    end
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
    @order = Order.joins('LEFT JOIN users ON orders.user_id = users.id').find(params[:id])
    @ordered_products = @order.ordered_products

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @order }
    end
  end

  # GET /orders/new
  # GET /orders/new.json
  def new
    @order = Order.new
    @ordered_products = OrderedProduct.get_new_ordered_products(current_user.id)

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @order }
    end
  end

  # GET /orders/1/edit
  def edit
    @order = Order.find(params[:id])
  end

  # POST /orders
  # POST /orders.json
  def create
    success = false
    @order = Order.new(params[:order])
    @order.user_id = current_user.id
    @order.total_price_per_day = get_total_price_per_day
    @order.total_price = @order.total_price_per_day * @order.duration_in_days + @order.delivery_cost

    respond_to do |format|
      begin
        Order.transaction do
          @order.save
          @ordered_products = OrderedProduct.get_new_ordered_products(current_user.id)
          @ordered_products.update_all("order_id = #{@order.id}")
          @ordered_products.each { |op| op.rented_products.update_all("order_id = #{@order.id}") }
        end
        format.html { redirect_to admin_order_path(@order), notice: 'Pesanan telah berhasil disimpan' }
      rescue ActiveRecord::RecordInvalid => invalid
        format.html { render action: "new" }
      end
    end
    #        if @order.save
    #          @ordered_products = OrderedProduct.get_new_ordered_products(current_user.id)
    #          if @ordered_products.update_all("order_id = #{@order.id}")
    #            format.html { redirect_to admin_products_path, notice: 'Order was successfully created.' }
    #          else
    #            format.html { render action: "new" }
    #            format.json { render json: @order.errors, status: :unprocessable_entity }
    #          end
    #        else
    #          format.html { render action: "new" }
    #          format.json { render json: @order.errors, status: :unprocessable_entity }
    #        end
  end

  # PUT /orders/1
  # PUT /orders/1.json
  def update
    @order = Order.find(params[:id])
    params[:order][:total_price] = @order.total_price_per_day * params[:order][:duration_in_days] + params[:order][:delivery_cost]

    respond_to do |format|
      if @order.update_attributes(params[:order])
        format.html { redirect_to [:admin, @order], notice: 'Order was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order = Order.find(params[:id])
    @order.destroy

    respond_to do |format|
      format.html { redirect_to orders_url }
      format.json { head :ok }
    end
  end

  def edit_detail
    @order = Order.find(params[:order_id])
    @ordered_products = @order.ordered_products
    @products = params[:name].blank? ? Product.page(params[:page]).per(10) : Product.where("name LIKE ?", "%#{params[:name]}%").page(params[:page]).per(10)

    respond_to do |format|
      format.html
      format.js
    end
  end

  #  def return_of_products
  #    @order = Order.find(params[:order_id])
  #    @ordered_products = @order.ordered_products
  #  end

  def payments
    @orders = Order.where("payment_status != 'Lunas'").joins('LEFT JOIN users ON orders.user_id = users.id')
  end

  def print
    @order = Order.find(params[:order_id])
    @ordered_products = @order.ordered_products
    @payments = @order.payments

#    respond_to do |format|
#      format.html
#    end
    render layout: 'print'
  end

  private
  def get_total_price_per_day
    OrderedProduct.where("user_id = ? AND order_id IS NULL", current_user.id).sum(:sub_total)
  end
end
