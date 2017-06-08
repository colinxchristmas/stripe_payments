# FactoryGirl.define do
#   factory :sale do
#     stripe_id "MyString"
#     add_foreign_key "MyString"
#      ""
#      ""
#   end
# end
FactoryGirl.define do
  factory :sale do
    stripe_id   ['ch_', Faker::Number.hexadecimal(10)].join('')
    association :product, factory: :product
    association :user, factory: :user
  end
end
