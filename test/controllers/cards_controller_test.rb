require 'test_helper'

class CardsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user_with_card)
    post user_session_path \
      "user[email]"    => @user.email,
      "user[password]" => @user.password
    @card = @user.cards[0]
  end

  test "should get index" do
    get cards_url
    assert_response :success
  end

  test "should get new" do
    get new_card_url
    assert_response :success
  end

  test "should create valid card" do
    # assert_difference('Card.count') do
    #   post '/users/cards', params(:valid)
    # end
    #
    # assert_redirected_to card_url(Card.last)
  end

  test "should create invalid card" do
    # post '/users/cards', params(:invalid), :headers => {"access-token" => @access_token , 'uid' => @user.email}
    # assert_response :success
  end

  test "should show card" do
    get card_url(@card)
    assert_response :success
  end

  test "should get edit" do
    get edit_card_url(@card)
    assert_response :success
  end

  test "should update valid card" do
    # patch card_url(@card), params(:valid), :headers => {"access-token" => @access_token , 'uid' => @user.email}
    # assert_redirected_to card_url(@card)
    # debugger
  end

  test "should update invalid card" do
    # patch card_url(@card), params(:invalid), :headers => {"access-token" => @access_token , 'uid' => @user.email}
    # assert_response :success
  end

  test "should destroy card" do
    assert_difference('Card.count', -1) do
      delete card_url(@card)
    end

    assert_redirected_to cards_url
  end

  def params(kind = :valid)
    case kind
    when :invalid
      {card_id: @card.id, stripe_id: '', card_name: '', card_last_four: '', card_type: '', card_exp_month: '', card_exp_year: '', default_card: '', user_id: '' }
    when :valid
      { stripe_id: 'card_39aNIDnadIsuah', card_name: 'Test Two-Card', card_last_four: '4242', card_type: 'Visa', card_exp_month: '12', card_exp_year: '2019', default_card: false, user_id: @user.id }
    end
  end
end
