FactoryGirl.define do
  factory :user do
    first_name        Faker::Name.first_name
    last_name         Faker::Name.last_name
    sequence(:email)  {|n| "#{n}-#{Faker::Internet.email}" }
    password          'abcd1234'


    factory :user_with_card do
      after(:create) do |user|
        create(:card, user: user)
      end
    end
  end
end
