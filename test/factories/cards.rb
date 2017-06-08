# FactoryGirl.define do
#   factory :card do
#     stripe_id "MyString"
#     card_name "MyString"
#     card_last_four 1
#     card_type "MyString"
#     card_exp_month "MyString"
#     card_exp_year 1
#     default_card false
#     user nil
#   end
# end
FactoryGirl.define do
  factory :card do
    stripe_id      ['card_', Faker::Number.hexadecimal(20)].join('')
    card_name      Faker::Name.name
    card_last_four Faker::Number.between(1000, 9999)
    card_type      "Visa"
    card_exp_month Faker::Number.between(1, 12)
    card_exp_year  Faker::Number.between(2018, 2030)
    default_card   true
    association :address, factory: :address
    association :user, factory: :user
  end
end
