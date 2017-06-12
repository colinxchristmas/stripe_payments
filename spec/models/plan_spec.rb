require 'rails_helper'
require 'spec_helper'
require 'stripe_mock'

RSpec.describe Plan, type: :model do

  describe 'validations' do
    def valid_attributes(new_attributes = {})
      {stripe_id: 'plan_stripe_id', name: 'First Plan', description: 'This is the plan.', interval: 'month', amount: 49 }.merge(new_attributes)
    end
    it 'requires a stripe id' do
      plan = Plan.new(valid_attributes({stripe_id: nil}))
      expect(plan).to be_invalid
    end
    it 'rejects duplicate stripe ids' do
      plan_1 = Plan.create(valid_attributes({stripe_id: 'plan_stripe_one'}))
      plan_2 = Plan.create(valid_attributes({stripe_id: 'plan_stripe_one'}))
      expect(plan_2).to be_invalid
    end
    it 'requires a name' do
      plan = Plan.new(valid_attributes({name: nil}))
      expect(plan).to be_invalid
    end
    it 'rejects duplicate names' do
      plan_1 = Plan.create(valid_attributes({name: 'Plan Stripe One'}))
      plan_2 = Plan.create(valid_attributes({name: 'Plan Stripe One'}))
      expect(plan_2).to be_invalid
    end
    it 'requires a description less than 23 chars' do
      plan = Plan.new(valid_attributes({description: 'This description is over the alloted chars'}))
      expect(plan).to be_invalid
    end
    it 'requires a description greater than 5 chars' do
      plan = Plan.new(valid_attributes({description: nil}))
      expect(plan).to be_invalid
    end
    it 'requires a interval' do
      plan = Plan.new(valid_attributes({interval: nil}))
      expect(plan).to be_invalid
    end
    it 'requires a price at least 50 cents' do
      plan = Plan.new(valid_attributes({amount: 49}))
      expect(plan).to be_invalid
    end
  end

  describe 'methods' do
    before(:each) do
      StripeMock.start
      @plan = FactoryGirl.create(:plan)
      
      @plan_day = FactoryGirl.build(:plan, :day)
      @plan_week = FactoryGirl.build(:plan, :week)
      @plan_month = FactoryGirl.build(:plan, :month)
      @plan_year = FactoryGirl.build(:plan, :year)
    end

    after(:each) do
      StripeMock.stop
    end
    it 'adds a plural to interval' do
      expect(@plan_day.plural_month).to eq("daily")
      expect(@plan_week.plural_month).to eq("weekly")
      expect(@plan_month.plural_month).to eq("monthly")
      expect(@plan_year.plural_month).to eq("yearly")
    end

    it 'adds joins price and interval with \'/\'' do
      expect(@plan.price_interval).to eq([sprintf("$%0.2f", @plan.amount / 100.0), @plan.plural_month].join ('/'))
    end

    it 'adds monetary formatting for plan amount' do
      expect(@plan.formatted_price).to eq(sprintf("$%0.2f", @plan.amount / 100.0))
    end
  end
end
