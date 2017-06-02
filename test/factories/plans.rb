FactoryGirl.define do
  factory :plan do
    stripe_id "MyString"
    name "MyString"
    description "MyString"
    amount 1
    interval "MyString"
    published false
  end
end
