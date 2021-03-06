FactoryGirl.define do
  factory :subscription do
    stripe_id          ['sub_', Faker::Number.hexadecimal(10)].join('')
    association :user, factory: :user
    association :plan, factory: :plan
  end
end
