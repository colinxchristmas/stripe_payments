# FactoryGirl.define do
#   factory :product do
#     name "MyString"
#     price 1
#     permalink "MyString"
#     description "MyText"
#     references ""
#   end
# end
FactoryGirl.define do
  factory :product do
    name                Faker::Commerce.product_name
    price               Faker::Number.number(4)
    permalink           'test-product'
    description         Faker::Lorem.sentence
    association :user, factory: :user
  end
end
