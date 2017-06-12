FactoryGirl.define do
  factory :user do
    first_name        Faker::Name.first_name
    last_name         Faker::Name.last_name
    sequence(:email)  {|n| "#{n}-#{Faker::Internet.email}" }
    password          'abcd1234'

    factory :user_with_card do
      # adds card and subsequent address associations
      after(:create) do |user|
        create(:card, user: user)
      end
    end

    factory :no_stripe_id do
      # resets the stripe_customer_id to empty string
      after(:create) do |user|
        user.stripe_customer_id = ''
      end
    end

    factory :user_no_card do
      # no after create method to avoid creating a card
    end

  end
end
