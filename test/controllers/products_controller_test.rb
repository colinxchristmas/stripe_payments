require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product = create(:product)
    @user = create(:user)
    post user_session_path \
      "user[email]"    => @user.email,
      "user[password]" => @user.password
  end

  test "should get index" do
    get products_url
    assert_response :success
  end

  test "should get new" do
    get new_product_url
    assert_response :success
  end

  test "should create product" do
    assert_difference('Product.count') do
      post products_url, params: { product: params(:valid) }
    end

    assert_redirected_to product_url(Product.last)
  end

  test "should create invalid product" do
    post products_url, params: { product: params(:invalid) }
    assert_response :success
  end

  test "should show product" do
    get product_url(@product)
    assert_response :success
  end

  test "should get edit" do
    get edit_product_url(@product)
    assert_response :success
  end

  test "should update valid product" do
    patch product_url(@product), params: { product: params(:valid) }
    assert_redirected_to product_url(@product)
  end

  test "should update invalid product" do
    patch product_path(@product), params: { product: params(:invalid) }
    assert_response :success
  end

  test "should destroy product" do
    assert_difference('Product.count', -1) do
      delete product_url(@product)
    end

    assert_redirected_to products_url
  end

  def params(kind = :valid)
    case kind
    when :invalid
      { name: '', price: '', permalink: '', description: '' }
    when :valid
      { name: 'Second Product', price: 1234, permalink: 'second-product', description: 'This is the second product', user_id: @user.id }
    end
  end
end
