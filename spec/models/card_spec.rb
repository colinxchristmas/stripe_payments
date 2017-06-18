require 'rails_helper'

RSpec.describe Card, type: :model do

  describe 'validations' do
    def valid_attributes(new_attributes = {})
      {stripe_id: 'card_stripeid', card_last_four: 4242, card_type: 'Visa', card_exp_month: 1, card_exp_year: 2018, card_name: 'Full D. Name'}.merge(new_attributes)
    end
    it 'requires a stripe id' do
      card = Card.new(valid_attributes({stripe_id: nil}))
      expect(card).to be_invalid
    end
    it 'requires a card last four' do
      card = Card.new(valid_attributes({card_last_four: nil}))
      expect(card).to be_invalid
    end
    it 'requires a card type' do
      card = Card.new(valid_attributes({card_type: nil}))
      expect(card).to be_invalid
    end
    it 'requires a card expiration month' do
      card = Card.new(valid_attributes({card_exp_month: nil}))
      expect(card).to be_invalid
    end
    it 'requires a card expiration year' do
      card = Card.new(valid_attributes({card_exp_year: nil}))
      expect(card).to be_invalid
    end
    it 'requires a card full name' do
      card = Card.new(valid_attributes({card_name: nil}))
      expect(card).to be_invalid
    end
  end

  describe 'methods' do
    before(:each) do
      StripeMock.start
      @card = FactoryGirl.create(:default_card_true)
      @user_cards = FactoryGirl.create(:user_two_cards)
    end

    after(:each) do
      StripeMock.stop
    end

    it 'formats default card *(Default) on true' do
      expect(@user_cards.cards[0].default?).to eq("*(Default)")
    end
    it 'returns empty string if user does not have default card' do
      expect(@user_cards.cards[1].default?).to eq("")
    end
    it 'returns checked string if card is default' do
      expect(@user_cards.cards[0].card_default?).to eq("checked")
    end
    it 'returns empty string if card is not default' do
      expect(@user_cards.cards[1].card_default?).to eq("")
    end
    it 'joins card_exp_month with card_exp_year with /' do
      expect(@card.card_exp_combined).to eq([@card.card_exp_month, @card.card_exp_year].join (' / '))
    end
  end
end
