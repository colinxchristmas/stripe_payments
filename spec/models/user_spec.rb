require 'rails_helper'

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
end
