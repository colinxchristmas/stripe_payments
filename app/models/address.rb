class Address < ApplicationRecord
  belongs_to :card
  has_paper_trail
end
