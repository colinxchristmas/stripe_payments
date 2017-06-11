class Address < ApplicationRecord
  belongs_to :card
  validates :address_line_one, :address_city, :address_state, :address_country, :address_zip, presence: true
  has_paper_trail
end
