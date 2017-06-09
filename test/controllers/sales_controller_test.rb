require 'test_helper'

class SalesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sale = create(:sale)
    @user = create(:user)
    @product = create(:product)
    # host! 'members.lvh.me:3000'
    post user_session_path \
      "user[email]"    => @user.email,
      "user[password]" => @user.password
  end

  test "should get index" do
    get sales_url
    assert_response :success
  end

  test "should get new" do
    get new_sale_url
    assert_response :success
  end

  test "should create sale" do
    assert_difference('Sale.count') do
      post sales_url, params: { sale: { : @sale., : @sale., add_foreign_key: @sale.add_foreign_key, stripe_id: @sale.stripe_id } }
    end

    assert_redirected_to sale_url(Sale.last)
  end

  test "should show sale" do
    get sale_url(@sale)
    assert_response :success
  end

  test "should get edit" do
    get "/members/sales/#{@sale.id}/edit" 
    assert_response :success
  end

  test "should update sale" do
    patch sale_url(@sale), params: { sale: { : @sale., : @sale., add_foreign_key: @sale.add_foreign_key, stripe_id: @sale.stripe_id } }
    assert_redirected_to sale_url(@sale)
  end

  test "should destroy sale" do
    assert_difference('Sale.count', -1) do
      delete sale_url(@sale)
    end

    assert_redirected_to sales_url
  end
end
