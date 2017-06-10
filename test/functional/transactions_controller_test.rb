require 'test_helper'

class TransactionsControllerTest < ActionController::TestCase
  setup do
    @token = 'tok_test'
    @product = create(:product)
    @user = create(:user_with_card)
    sign_in(@user)
  end
  test "should post create" do
    # needs work for stripe ruby mock integration
    
    # post :create, params: {permalink: @product.permalink, user: @user,  stripeToken: @token}
    #
    # assert_redirected_to show_purchases_path
  end
end
