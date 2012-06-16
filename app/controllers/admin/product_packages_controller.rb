class Admin::ProductPackagesController < ApplicationController
  before_filter :admin_required
  layout nil, :only => :new
  
  def new
    @product = Product.find(params[:product_id])
    @product_package = ProductPackage.new(:parent_id => params[:product_id])
    @product_packages = ProductPackage.where(:parent_id => params[:product_id])
#    temp = @product_packages.
    @products = Product.available_for_package(params[:product_id])
  end

  def create
    @product_package = ProductPackage.new(params[:product_package])
    
    respond_to do |format|
      if @product_package.triggered_save
        format.html { redirect_to [:admin, @product_package.parent], notice: 'Produk telah tersimpan sebagai paket' }
      else
        flash[:error] = 'Tidak dapat menyimpan data'
        format.html { redirect_to [:admin, @product_package.parent] }
      end
    end
  end

  def destroy
    @product_package = ProductPackage.where(:parent_id => params[:product_id], :child_id => params[:id])
    @product_package.destroy_all
    
    respond_to do |format|
      format.html { redirect_to admin_product_path(params[:product_id]) }
    end
  end
end


