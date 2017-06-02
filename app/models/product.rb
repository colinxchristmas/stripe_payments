class Product < ApplicationRecord
  belongs_to :user

  validates :name, :permalink, :description, presence: true

  validates_numericality_of :price,
    greater_than: 49,
  message: "must be at least 50 cents"
end
