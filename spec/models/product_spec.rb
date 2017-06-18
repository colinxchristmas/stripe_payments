require 'rails_helper'

RSpec.describe Product, type: :model do

  describe 'validations' do
    def valid_attributes(new_attributes = {})
      {name: 'Product Name', description: 'This is a description', permalink: 'product-name', price: 50}.merge(new_attributes)
    end
    it 'requires a name' do
      product = Product.new(valid_attributes({name: nil}))
      expect(product).to be_invalid
    end
    it 'requires a description' do
      product = Product.new(valid_attributes({description: nil}))
      expect(product).to be_invalid
    end
    it 'requires a permalink' do
      product = Product.new(valid_attributes({permalink: nil}))
      expect(product).to be_invalid
    end
    it 'requires a price at least 50 cents' do
      product = Product.new(valid_attributes({price: 49}))
      expect(product).to be_invalid
    end
  end
end
