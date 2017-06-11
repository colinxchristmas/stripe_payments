require 'rails_helper'

RSpec.describe UsersHelper, type: :helper do
  # def full_name
  #   [first_name, last_name].join (' ')
  # end
  describe 'user full name' do
    it 'returns the user\'s full name' do
      user = User.new(first_name: 'Test', last_name: 'Last')
      expect(helper.full_name).to match /Test Last
    end
  end
end
