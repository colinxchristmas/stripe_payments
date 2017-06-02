class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :plan
  accepts_nested_attributes_for :plan
end
