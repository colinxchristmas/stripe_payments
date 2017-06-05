class Product < ApplicationRecord
  belongs_to :user
  has_many   :sales

  validates :name, :description, presence: true
  validates :permalink, presence: true, uniqueness: true

  validates_numericality_of :price,
    greater_than: 49,
  message: "must be at least 50 cents"
end
