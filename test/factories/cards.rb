FactoryGirl.define do
  factory :card do
    stripe_id "MyString"
    card_name "MyString"
    card_last_four 1
    card_type "MyString"
    card_exp_month "MyString"
    card_exp_year 1
    default_card false
    user nil
  end
end
