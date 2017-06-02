class Sale < ApplicationRecord
  belongs_to :product
  belongs_to :user
  has_paper_trail
end
