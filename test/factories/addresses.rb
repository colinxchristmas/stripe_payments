FactoryGirl.define do
  factory :address do
    address_line_one "MyString"
    address_line_two "MyString"
    address_city "MyString"
    address_state "MyString"
    address_country "MyString"
    address_zip "MyString"
    user nil
  end
end
