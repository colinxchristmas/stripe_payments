require 'test_helper'
require 'stripe_mock'

class TransactionsControllerTest < ActionController::TestCase
  setup do
    @product = create(:product)
    @user = create(:user_no_card)
    # build card and address to avoid association errors on the Services.call methods.
    @card = build(:card)
    @address = build(:address)
    create_stripe_card_token

    sign_in(@user)
  end
  test "should post new charge" do
    post :create, params: permalink
    assert_redirected_to show_purchases_url
  end

  def charge_params
    {amount: @product.price, description: @product.name, receipt_email: @user.email}
  end

  def card_params
    {id: @card.id, stripe_id: @card.stripe_id, card_name: @card.card_name, card_last_four: @card.card_last_four, card_type: @card.card_type, card_exp_month: @card.card_exp_month, card_exp_year: @card.card_exp_year, user_id: @user.id}
  end

  def card_form_params
    {card_on_file: nil}
  end

  def address_params
    {address_line_one: @address.address_line_one, address_line_two: @address.address_line_two, address_city: @address.address_city, address_state: @address.address_state, address_zip: @address.address_zip, address_country: @address.address_country}
  end

  def permalink
    {permalink: @product.permalink}
  end

  private

  def create_stripe_card_token
    # In the Stripe JS process the token creates a stripe_id for the card
    # It's passed through the form so the process below is doing the same thing
    customer = Stripe::Customer.retrieve(@user.stripe_customer_id)
    customer.source = StripeMock.generate_card_token
    customer.save
    @card.stripe_id = customer.default_source
  end
end
