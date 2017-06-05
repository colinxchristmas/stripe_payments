class Address < ApplicationRecord
  belongs_to :user
  has_paper_trail
end
