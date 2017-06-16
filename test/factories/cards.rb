FactoryGirl.define do
  factory :card do
    stripe_id ['t_card_', Faker::Number.hexadecimal(20)].join('')

    card_name      Faker::Name.name
    card_last_four Faker::Number.between(1000, 9999)
    card_type      "Visa"
    card_exp_month Faker::Number.between(1, 12)
    card_exp_year  Faker::Number.between(2018, 2030)

    factory :default_card_true do
      default_card true
    end

    factory :default_card_false do
      default_card false
    end

    association :user, factory: :user
    after(:create) do |card|
      create(:address, card: card)
    end

    after(:build) do |card|
      build(:address, card: card)
    end
  end
end
