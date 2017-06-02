FactoryGirl.define do
  factory :subscription do
    stripe_id "MyString"
    user nil
    plan nil
  end
end
