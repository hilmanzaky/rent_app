class Admin::OrderedProductsController < ApplicationController
  before_filter :admin_required
  after_filter :flash_error

  def flash_error
    if !@ordered_product.flash_error.blank?
      flash[:error] = @ordered_product.flash_error
    end
  end

  # GET /ordered_products
  # GET /ordered_products.json
  def index
    @ordered_products = OrderedProduct.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @ordered_products }
    end
  end

  # GET /ordered_products/1
  # GET /ordered_products/1.json
  def show
    @ordered_product = OrderedProduct.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @ordered_product }
    end
  end

  # GET /ordered_products/new
  # GET /ordered_products/new.json
  def new
    @product = Product.find(params[:product_id])
    @ordered_product = OrderedProduct.new(:product_id => params[:product_id], :order_id => params[:order_id],
      :qty => 1)
    if @product.is_dimensional? and @product.is_package?
#      @product_packages = @product.direct_childs
      @rented_products = RentedProduct.find_by_sql("SELECT product_id as id, name, NULL as rented_qty
                                                    FROM
                                                      (SELECT child_id as product_id
                                                       FROM product_packages
                                                       WHERE parent_id = #{params[:product_id]}) childs
                                                    LEFT JOIN products p ON childs.product_id = p.id")
    end
    render layout: false
  end

  # GET /ordered_products/1/edit
  def edit
    @ordered_product = OrderedProduct.find(params[:id])
    @product = @ordered_product.product
    if @product.is_dimensional? and @product.is_package?
      #      @product_packages = @product.direct_childs.joins("LEFT JOIN (SELECT product_id, rented_qty
      #FROM rented_products
      #WHERE ordered_product_id = 34) rp ON product_packages.child_id = rp.product_id#")
      #      .select("product_packages.id, name, rented_qty as qty")
      @rented_products = RentedProduct.find_by_sql("SELECT p.id, p.name, rented_qty
                                                    FROM
                                                      (SELECT child_id as product_id
                                                       FROM product_packages
                                                       WHERE parent_id = #{@product.id}) childs
                                                      LEFT JOIN (SELECT product_id, rented_qty
                                                                 FROM rented_products
                                                                 WHERE ordered_product_id = #{@ordered_product.id}) rp ON childs.product_id = rp.product_id
                                                      LEFT JOIN products p ON childs.product_id = p.id")
    end
    render layout: false
  end

  # POST /ordered_products
  # POST /ordered_products.json
  def create
    @ordered_product = OrderedProduct.new(params[:ordered_product])
    rented_products = params['rented_products'] ? params['rented_products'] : {}
    #    p product_packages
    respond_to do |format|
      format.html { redirect_to @ordered_product.complex_triggered_save(current_user.id, rented_products) }
    end
  end


  # PUT /ordered_products/1
  # PUT /ordered_products/1.json
  def update
    @ordered_product = OrderedProduct.find(params[:id])
    rented_products = params['rented_products'] ? params['rented_products'] : {}

    respond_to do |format|
      format.html { redirect_to @ordered_product.complex_triggered_update(params[:ordered_product], rented_products)}
    end
  end
  
  # fix version with no errors
  #  def create
  #    @ordered_product = OrderedProduct.new(params[:ordered_product])
  #    product = @ordered_product.product
  #    success = true
  #    err_msg = []
  #
  #    respond_to do |format|
  #      OrderedProduct.transaction do
  #        if product.is_package?  # apakah barang yang dipesan merupakan barang paket
  #          product.childs.each do |p|  # setiap barang dalam paket tersebut
  #            total_reduced_stocks = p.reduced_stocks * @ordered_product.qty # menghitung total qty barang yang akan berkurang
  #            if p.child.stock < total_reduced_stocks # apabila stok barang tidak mencukupi
  #              success = false
  #              err_msg << "Stok #{p.child.name} tidak mencukupi"
  #            else
  #              p.child.update_attribute(:stock, p.child.stock - total_reduced_stocks) if success
  #            end
  #          end
  #          if success
  #            set_up_ordered_product_for_create
  #
  #            if @ordered_product.save_and_reduce_stock(params[:ordered_product])
  #              if @ordered_product.order_id.blank?
  #                format.html { redirect_to admin_products_path, notice: 'Ordered  product was successfully created.' }
  #              else
  #                change_order_total
  #                format.html { redirect_to admin_order_edit_detail_path(@ordered_product.order_id), notice: 'Barang telah disimpan ke dalam order' }
  #              end
  #            else
  #              format.html { render action: "new" }
  #              raise ActiveRecord::Rollback
  #            end
  #          else
  #            flash[:error] = "Melebihi stok" + "<ul><li>#{err_msg.join("</li><li>")}</li></ul>"
  #            if @ordered_product.order_id.blank?
  #              format.html { redirect_to admin_products_path }
  #            else
  #              format.html { redirect_to admin_order_edit_detail_path(@ordered_product.order_id) }
  #            end
  #            raise ActiveRecord::Rollback
  #          end
  #        else
  #          unless @ordered_product.product.stock < @ordered_product.qty
  #            set_up_ordered_product_for_create
  #
  #            if @ordered_product.save_and_reduce_stock(params[:ordered_product])
  #              if @ordered_product.order_id.blank?
  #                format.html { redirect_to admin_products_path, notice: 'Ordered product was successfully created.' }
  #              else
  #                change_order_total
  #                format.html { redirect_to admin_order_edit_detail_path(@ordered_product.order_id), notice: 'Barang telah disimpan ke dalam order' }
  #              end
  #            else
  #              raise ActiveRecord::Rollback and return false
  #              format.html { render action: "new" }
  #            end
  #          else
  #            flash[:error] = 'Melebihi stok'
  #            if @ordered_product.order_id.blank?
  #              format.html { redirect_to admin_products_path }
  #            else
  #              format.html { redirect_to admin_order_edit_detail_path(@ordered_product.order_id) }
  #            end
  #          end
  #        end
  #      end
  #    end
  #  end

  #  def update
  #    @ordered_product = OrderedProduct.find(params[:id])
  #    product = @ordered_product.product
  #    success = true
  #    err_msg = []
  #
  #    respond_to do |format|
  #      OrderedProduct.transaction do
  #        if product.is_package? # jika yang dipilih adalah paket barang
  #          product.childs.each do |p|  # setiap barang dalam paket tersebut
  #            total_reduced_stocks = p.reduced_stocks * (@ordered_product.qty - params[:ordered_product][:qty].to_i) # menghitung total qty barang yang akan berkurang
  #            if p.child.stock < -(total_reduced_stocks) # apabila stok barang tidak mencukupi
  #              success = false
  #              err_msg << "Stok #{p.child.name} tidak mencukupi"
  #            else
  #              p.child.update_attribute(:stock, p.child.stock + total_reduced_stocks) if success # stok sekarang - total qty lama + total qty baru
  #            end
  #          end
  #          if success
  #            params[:ordered_product][:sub_total] = @ordered_product.rent_price * params[:ordered_product][:qty].to_i
  #
  #            if @ordered_product.save_and_reduce_stock(params[:ordered_product])  # termasuk mengurangi stok produk
  #              if @ordered_product.order_id.blank?
  #                format.html { redirect_to admin_products_path, notice: 'Ordered  product was successfully created.' }
  #              else
  #                change_order_total
  #                format.html { redirect_to admin_order_edit_detail_path(@ordered_product.order_id), notice: 'Barang telah disimpan ke dalam order' }
  #              end
  #            else
  #              format.html { render action: "new" }
  #              raise ActiveRecord::Rollback
  #            end
  #          else
  #            flash[:error] = "Melebihi stok" + "<ul><li>#{err_msg.join("</li><li>")}</li></ul>"
  #            if @ordered_product.order_id.blank?
  #              format.html { redirect_to admin_products_path }
  #            else
  #              format.html { redirect_to admin_order_edit_detail_path(@ordered_product.order_id) }
  #            end
  #            raise ActiveRecord::Rollback
  #          end
  #        else # jika bukan merupakan paket barang
  #          unless @ordered_product.product.stock < params[:ordered_product][:qty].to_i
  #            params[:ordered_product][:sub_total] = @ordered_product.rent_price * params[:ordered_product][:qty].to_i
  #
  #            if @ordered_product.save_and_reduce_stock(params[:ordered_product])
  #              if @ordered_product.order_id.blank?
  #                format.html { redirect_to admin_products_path, notice: 'Ordered product was successfully updated.' }
  #              else
  #                change_order_total
  #                format.html { redirect_to admin_order_edit_detail_path(@ordered_product.order_id), notice: 'Barang telah disimpan ke dalam order' }
  #              end
  #            else
  #              raise ActiveRecord::Rollback and return false
  #              format.html { render action: "edit" }
  #            end
  #          else
  #            flash[:error] = 'Melebihi stok'
  #            if @ordered_product.order_id.blank?
  #              format.html { redirect_to admin_products_path }
  #            else
  #              format.html { redirect_to admin_order_edit_detail_path(@ordered_product.order_id) }
  #            end
  #          end
  #        end
  #      end
  #    end
  #  end

  # DELETE /ordered_products/1
  # DELETE /ordered_products/1.json
  def destroy
    @ordered_product = OrderedProduct.find(params[:id])
    product = @ordered_product.product
    order_id = @ordered_product.order_id

    @ordered_product.triggered_destroy

    respond_to do |format|
      if order_id.blank?
        format.html { redirect_to admin_products_path }
      else
        change_order_total
        format.html { redirect_to admin_order_edit_detail_path(order_id) }
      end
    end
  end

  def update_returned_products
    #    p params
  end

  private
  def set_up_ordered_product_for_create
    @ordered_product.user_id = current_user.id
    @ordered_product.price = @ordered_product.product.price
    @ordered_product.rent_price = @ordered_product.product.rent_price
    @ordered_product.sub_total = @ordered_product.rent_price * @ordered_product.qty
  end

  def change_order_total
    @order = @ordered_product.order
    order = {}
    order[:total_price_per_day] = @order.ordered_products.sum(:sub_total)
    order[:total_price] = order[:total_price_per_day] * @order.duration_in_days + @order.delivery_cost
    @order.update_attributes(order)
  end
end
