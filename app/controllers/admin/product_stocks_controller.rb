class Admin::ProductStocksController < ApplicationController
  before_filter :admin_required
  #  layout nil, :only => :new
  
  # GET /product_stocks
  # GET /product_stocks.json
  def index
    @product = Product.find(params[:product_id])
    @product_stocks = @product.product_stocks

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @product_stocks }
    end
  end

  # GET /product_stocks/1
  # GET /product_stocks/1.json
  def show
    @product_stock = ProductStock.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @product_stock }
    end
  end

  # GET /product_stocks/new
  # GET /product_stocks/new.json
  def new
    @product_stock = ProductStock.new(:product_id => params[:product_id])
    render layout: false
  end

  # GET /product_stocks/1/edit
  def edit
    @product_stock = ProductStock.find(params[:id])
    render layout: false
  end

  # POST /product_stocks
  # POST /product_stocks.json
  def create
    @product_stock = ProductStock.new(params[:product_stock])

    respond_to do |format|
      if @product_stock.triggered_save
        format.html { redirect_to admin_product_product_stocks_path(@product_stock.product), notice: 'Product stock was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /product_stocks/1
  # PUT /product_stocks/1.json
  def update
    @product_stock = ProductStock.find(params[:id])

    respond_to do |format|
      ProductStock.transaction do
        if @product_stock.update_stock_history(params[:product_stock], params[:description]) &&
            @product_stock.triggered_update_attributes(params[:product_stock])
          format.html { redirect_to admin_product_product_stocks_path(@product_stock.product), notice: 'Product stock was successfully updated.' }
        else
          format.html { render action: "edit" }
        end
      end
    end
  end

  # DELETE /product_stocks/1
  # DELETE /product_stocks/1.json
  def destroy
    @product_stock = ProductStock.find(params[:id])
    @product_stock.destroy

    respond_to do |format|
      format.html { redirect_to product_stocks_url }
      format.json { head :ok }
    end
  end
end
