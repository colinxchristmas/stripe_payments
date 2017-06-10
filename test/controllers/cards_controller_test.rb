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
    # Needs stripe mock integrated to work properly
  end

  test "should create invalid card" do
    # Needs stripe mock integrated to work properly
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
    # Needs stripe mock integrated to work properly
  end

  test "should update invalid card" do
    # Needs stripe mock integrated to work properly
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

  def card_params
    { stripe_id: 'card_39aNIDnadIsuah', card_name: 'Test Two-Card', card_last_four: '4242', card_type: 'Visa', card_exp_month: '12', card_exp_year: '2019', default_card: false, user_id: @user.id }
  end

  def card_additional_params
    {address_line_one: @card.address.address_line_one, address_line_two: 'Apt 2', address_city: @card.address.address_city, address_state: @card.address.address_state, address_zip: @card.address.address_zip, address_country: @card.address.address_country, default_card: 'false', user_id: @user.id}
  end
end
