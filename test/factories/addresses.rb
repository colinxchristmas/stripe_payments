FactoryGirl.define do
  factory :address do
    address_line_one  Faker::Address.street_address
    address_line_two  "Apt 1"
    address_city      Faker::Address.city
    address_state     Faker::Address.state
    address_country   Faker::Address.country_code
    address_zip       Faker::Address.zip
  end
end
