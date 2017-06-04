require 'test_helper'

class CardsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @card = cards(:one)
  end

  test "should get index" do
    get cards_url
    assert_response :success
  end

  test "should get new" do
    get new_card_url
    assert_response :success
  end

  test "should create card" do
    assert_difference('Card.count') do
      post cards_url, params: { card: { =: @card.=, card_exp_month: @card.card_exp_month, card_exp_year: @card.card_exp_year, card_last_four: @card.card_last_four, card_name: @card.card_name, card_type: @card.card_type, default_card: @card.default_card, stripe_id: @card.stripe_id, user_id: @card.user_id } }
    end

    assert_redirected_to card_url(Card.last)
  end

  test "should show card" do
    get card_url(@card)
    assert_response :success
  end

  test "should get edit" do
    get edit_card_url(@card)
    assert_response :success
  end

  test "should update card" do
    patch card_url(@card), params: { card: { =: @card.=, card_exp_month: @card.card_exp_month, card_exp_year: @card.card_exp_year, card_last_four: @card.card_last_four, card_name: @card.card_name, card_type: @card.card_type, default_card: @card.default_card, stripe_id: @card.stripe_id, user_id: @card.user_id } }
    assert_redirected_to card_url(@card)
  end

  test "should destroy card" do
    assert_difference('Card.count', -1) do
      delete card_url(@card)
    end

    assert_redirected_to cards_url
  end
end
