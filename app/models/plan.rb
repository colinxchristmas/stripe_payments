class Plan < ApplicationRecord
  validates :stripe_id, :name, uniqueness: true, presence: true
  validates :description, presence: true
  validates :interval, presence: true

  validates_numericality_of :amount,
    greater_than: 49,
  message: "must be at least 50 cents"
end
