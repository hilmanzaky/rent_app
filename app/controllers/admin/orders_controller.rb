class Admin::OrdersController < ApplicationController
  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.joins('LEFT JOIN users ON orders.user_id = users.id').
      order("delivery_date DESC, usage_date DESC")
    if params[:delivery_date].blank? and params[:usage_date].blank?
      params[:delivery_date] = Time.now.strftime("%Y-%m-%d")
    end
    @orders = @orders.where("delivery_date = ?", params[:delivery_date]) unless params[:delivery_date].blank?
    @orders = @orders.where("usage_date = ?", params[:usage_date]) unless params[:usage_date].blank?
    @orders = @orders.page(params[:page]).per(10).order("created_at DESC")

    @order = Order.new(:delivery_date => params[:delivery_date], :usage_date => params[:usage_date])

    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
    @order = Order.joins('LEFT JOIN users ON orders.user_id = users.id').find(params[:id])
    @ordered_products = @order.ordered_products
    @payments = @order.payments.order('created_at ASC')
    @grand_total = @ordered_products.sum(:sub_total) * @order.duration_in_days + @order.delivery_cost
    @total_payment = @payments.sum(:amount)

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
    #    success = false
    params[:order][:delivery_cost] = normal_format(params[:order][:delivery_cost])
    params[:payment] = normal_format(params[:payment])
    @order = Order.new(params[:order])
    @order.user_id = current_user.id
    @order.total_price_per_day = get_total_price_per_day
    @order.total_price = @order.total_price_per_day * @order.duration_in_days + @order.delivery_cost
    @ordered_products = OrderedProduct.get_new_ordered_products(current_user.id)

    respond_to do |format|
      begin
        Order.transaction do
          @order.save
          @ordered_products.each do |op|
            op.rented_products.update_all("order_id = #{@order.id}")
          end
          @ordered_products.update_all("order_id = #{@order.id}")
          Payment.create(:amount => params[:payment], :order_id => @order.id) if @order.payment_status == "Down Payment"
        end
        format.html { redirect_to admin_order_path(@order), notice: 'Pesanan telah berhasil disimpan' }
      rescue ActiveRecord::RecordInvalid => invalid
        format.html { render action: "new" }
      end
    end
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
    rp = ReturnedProduct.joins("LEFT JOIN rented_products rp ON returned_products.rented_product_id = rp.id
                                LEFT JOIN orders o ON rp.order_id = o.id").
      where("rp.order_id = ?", params[:id])
    if rp.blank?
      if @order.destroy
        flash[:notice] = "Pesanan telah dihapus"
      else
        flash[:error] = "Pesanan tidak dapat dihapus"
      end
    else
      flash[:error] = "Pesanan telah berjalan dan tidak dapat dihapus"
    end

    respond_to do |format|
      format.html { redirect_to admin_orders_url }
      format.json { head :ok }
    end
  end

  def edit_detail
    @order = Order.find(params[:order_id])
    @ordered_products = @order.ordered_products
    #    @products = Product.where("is_rented = ?", 1).page(params[:page]).per(10).order("created_at DESC")
    @products = Product.stocks_at(params[:usage_date]).page(params[:page]).per(10)
    @product = Product.new
    
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

  def print_deliver
    @order = Order.find(params[:order_id])
    @order.update_attribute(:is_delivered, true)
    @ordered_products = @order.ordered_products

    render layout: 'print'
  end

  def books
    @orders = Order.order("created_at DESC").page(params[:page]).per(10)
    @products = Product.select("id, name").order("name ASC").where("is_package = ?", 0)
  end

  def build
    params[:is_rented] = 'true' if params[:is_rented].blank?

    if params[:usage_date].blank?
      time = Time.new
      params[:usage_date] = time.strftime("%Y-%m-%d")
    end
    
    @usage_date = params[:usage_date]

    #    @products = Product.stocks_in(params[:rent_date]).where("name LIKE ? AND is_rented = ?", "%#{params[:name]}%", params[:is_rented] == 'true' ? 1 : 0)
    #    @products = @products.page(params[:page]).per(10).order("b.created_at DESC")
    #    @products = Product.where("name LIKE ? AND is_rented = ?", "%#{params[:name]}%", params[:is_rented] == 'true' ? 1 : 0)
    #    @products = @products.where("is_package = ?", params[:is_package] == 'true' ? 1 : 0) unless params[:is_package].blank?
    #    @products = @products.where("is_dimensional = ?", params[:is_dimensional] == 'true' ? 1 : 0) unless params[:is_dimensional].blank?
    #    @products = @products.page(params[:page]).per(10).order("created_at DESC")
    

    @products = Product.stocks_at(params[:usage_date]).page(params[:page]).per(10)

    if params[:order_id].blank?
      @ordered_products = OrderedProduct.where(:user_id => current_user.id, :order_id => nil)
      #      @order = Order.new(:usage_date => params[:usage_date])
    else
      @order = Order.find(params[:order_id])
      @ordered_products = @order.ordered_products
    end
    @product = Product.new(:name => params[:name], :is_rented => params[:is_rented],
      :is_package => params[:is_package], :is_dimensional => params[:is_dimensional])

    respond_to do |format|
      format.html
      format.js
    end
  end

  private
  def get_total_price_per_day
    OrderedProduct.where("user_id = ? AND order_id IS NULL", current_user.id).sum(:sub_total)
  end
end
