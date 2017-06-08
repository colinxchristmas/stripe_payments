# FactoryGirl.define do
#   factory :plan do
#     stripe_id "MyString"
#     name "MyString"
#     description "MyString"
#     amount 1
#     interval "MyString"
#     published false
#   end
# end
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
  end
end
