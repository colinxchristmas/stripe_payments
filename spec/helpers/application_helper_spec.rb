require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  def amount
    1000
  end
  describe 'formatted_price' do
    it 'returns a formatted money string' do
      expect(helper.formatted_price(amount)).to eq('$10.00')
    end
  end
end
