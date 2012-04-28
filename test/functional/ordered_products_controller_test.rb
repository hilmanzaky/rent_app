require 'test_helper'

class OrderedProductsControllerTest < ActionController::TestCase
  setup do
    @ordered_product = ordered_products(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ordered_products)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ordered_product" do
    assert_difference('OrderedProduct.count') do
      post :create, ordered_product: @ordered_product.attributes
    end

    assert_redirected_to ordered_product_path(assigns(:ordered_product))
  end

  test "should show ordered_product" do
    get :show, id: @ordered_product.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @ordered_product.to_param
    assert_response :success
  end

  test "should update ordered_product" do
    put :update, id: @ordered_product.to_param, ordered_product: @ordered_product.attributes
    assert_redirected_to ordered_product_path(assigns(:ordered_product))
  end

  test "should destroy ordered_product" do
    assert_difference('OrderedProduct.count', -1) do
      delete :destroy, id: @ordered_product.to_param
    end

    assert_redirected_to ordered_products_path
  end
end
