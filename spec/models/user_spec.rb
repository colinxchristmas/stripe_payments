require 'rails_helper'
require 'spec_helper'
require 'stripe_mock'

RSpec.describe User, type: :model do

  describe 'validations' do
    def valid_attributes(new_attributes = {})
      {first_name: "First", last_name: "Last"}.merge(new_attributes)
    end
    it 'requires a first name' do
      user = User.new(valid_attributes({first_name: nil}))
      expect(user).to be_invalid
    end
    it 'requires a last name' do
      user = User.new(valid_attributes({last_name: nil}))
      expect(user).to be_invalid
    end
  end

  describe 'methods' do
    before(:each) do
      StripeMock.start
      @user = FactoryGirl.create(:user_with_card)
      @user_no_card = FactoryGirl.create(:user_no_card)
    end

    after(:each) do
      StripeMock.stop
    end

    it 'returns a full name' do
      expect(@user.full_name).to eq([@user.first_name, @user.last_name].join(' '))
    end
    it 'returns a true stripe_customer_id' do
      expect(@user.stripe_customer_id?).to eq(true)
    end
    it 'returns a false stripe_customer_id if no stripe_customer_id' do
      @user_no_stripe_id = FactoryGirl.create(:no_stripe_id)
      expect(@user_no_stripe_id.stripe_customer_id?).to eq(false)
    end
    it 'returns true if card exists' do
      expect(@user.card_exists?).to eq(true)
    end
    it 'returns false if card does not exist' do
      expect(@user_no_card.card_exists?).to eq(false)
    end
    it 'returns hidden if card exists' do
      expect(@user.hidden_fields?).to eq('hidden')
    end
    it 'returns empty string if card does not exist' do
      expect(@user_no_card.hidden_fields?).to eq("")
    end
    it 'returns hidden string if first time buyer' do
      expect(@user_no_card.first_time_buyer?).to eq("hidden")
    end
    it 'returns empty string if not first time buyer' do
      expect(@user.first_time_buyer?).to eq("")
    end
  end
end
