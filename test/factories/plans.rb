FactoryGirl.define do
  factory :plan do
    sequence :stripe_id do |n|
      "plan_#{n}"
    end

    name          { Faker::Commerce.product_name }
    description   Faker::Lorem.characters(23)
    amount        Faker::Number.number(4)
    interval      'month'
    published     Faker::Boolean.boolean

    trait :day do
      interval 'day'
    end

    trait :month do
      interval 'month'
    end

    trait :year do
      interval 'year'
    end

    trait :week do
      interval 'week'
    end

    factory :valid_stripe_plan do
      # creates a valid plan with stripe ruby mock
      # technically this isn't used at the moment.
      after(:create) do |plan|
        plan = Stripe::Plan.create(
                                    id: plan.stripe_id,
                                    amount: plan.amount,
                                    currency: 'usd',
                                    interval: 'month',
                                    name: plan.name,
                                    statement_descriptor: 'TS ' + plan.name,
                                  )
      end
    end
  end
end
