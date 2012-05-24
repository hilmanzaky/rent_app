class Admin::ProductsController < ApplicationController
  before_filter :admin_required
  # GET /products
  # GET /products.json
  def index
    params[:is_rented] = 'true' if params[:is_rented].blank?
    @products = Product.where("name LIKE ? AND is_rented = ?", "%#{params[:name]}%", params[:is_rented] == 'true' ? 1 : 0)
    @products = @products.where("is_package = ?", params[:is_package] == 'true' ? 1 : 0) unless params[:is_package].blank?
    @products = @products.where("is_dimensional = ?", params[:is_dimensional] == 'true' ? 1 : 0) unless params[:is_dimensional].blank?
    @products = @products.page(params[:page]).per(10).order("created_at DESC")
    if params[:order_id].blank?
      @ordered_products = OrderedProduct.where(:user_id => current_user.id, :order_id => nil)
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

  # GET /products/1
  # GET /products/1.json
  def show
    @product = Product.find(params[:id])
    @product_packages = ProductPackage.where(:parent_id => params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @product }
    end
  end

  # GET /products/new
  # GET /products/new.json
  def new
    @product = Product.new
    @product.is_rented = true
    render layout: false
  end

  # GET /products/1/edit
  def edit
    @product = Product.find(params[:id])
    render layout: false
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(params[:product])

    respond_to do |format|
      if @product.triggered_save
        format.html { redirect_to [:admin, @product], notice: 'Product was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /products/1
  # PUT /products/1.json
  def update
    @product = Product.find(params[:id])

    respond_to do |format|
      if @product.triggered_update_attributes(params[:product])
        format.html { redirect_to [:admin, @product], notice: 'Product was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: [:admin, @product.errors], status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product = Product.find(params[:id])
    @product.triggered_destroy

    respond_to do |format|
      format.html { redirect_to admin_products_url }
      format.json { head :ok }
    end
  end

  def order
    @ordered_product = OrderedProduct.new(:user_id => current_user.id,
      :product_id => params[:id],
      :qty => 1)
  end

  #  def save_order
  #    @product = Product.find(params[:id])
  #    @ordered_product = OrderedProduct.where(:user_id => current_user.id, :product_id => params[:id])
  #
  #    unless @ordered_product.blank?
  #      @ordered_product.update_attribute(:qty => @ordered_product.qty + 1,
  #                                        :sub_total => @product.rent_price * (@ordered_product.qty + 1))
  #    else
  #      @ordered_product = OrderedProduct.new(:user_id => current_user.id,
  #                                            :product_id => params[:id],
  #                                            :qty => 1,
  #                                            :sub_total => @product.rent_price)
  #    end
  #    @ordered_product.save
  #
  #    respond_to do |format|
  #      format.html { redirect_to admin_products_url }
  #      format.js
  #    end
  #  end
end
