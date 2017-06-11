require 'rails_helper'

RSpec.describe Address, type: :model do

  describe 'validations' do
    def valid_attributes(new_attributes = {})
      {address_line_one: '1234 Test St.', address_city: 'City', address_state: 'CA', address_country: 'US', address_zip: '91827'}.merge(new_attributes)
    end
    it 'requires a address line one' do
      address = Address.new(valid_attributes({address_line_one: nil}))
      expect(address).to be_invalid
    end
    it 'requires a card last four' do
      address = Address.new(valid_attributes({address_city: nil}))
      expect(address).to be_invalid
    end
    it 'requires a card type' do
      address = Address.new(valid_attributes({address_state: nil}))
      expect(address).to be_invalid
    end
    it 'requires a card expiration month' do
      address = Address.new(valid_attributes({address_country: nil}))
      expect(address).to be_invalid
    end
    it 'requires a card expiration year' do
      address = Address.new(valid_attributes({address_zip: nil}))
      expect(address).to be_invalid
    end
  end
end
