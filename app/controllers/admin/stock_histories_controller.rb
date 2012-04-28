class Admin::StockHistoriesController < ApplicationController
  before_filter :admin_required

  def index
    @product_stock = ProductStock.find(params[:product_stock_id])
    @stock_histories = @product_stock.stock_histories
    render layout: false
  end
end
