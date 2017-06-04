class Card < ApplicationRecord
  belongs_to :user
  # has_one :address, dependent: :destroy

  # accepts_nested_attributes_for :address
  has_paper_trail

  validates :stripe_id, :card_last_four, :card_type, :card_exp_month, :card_exp_year, :card_name, presence: true

  def default?
    default_card? ? '*(Default)' : ''
  end

  def card_exists?(user)
    all_cards = user.cards.all.count
    all_cards >= 0
  end

  def card_on_file(card)
    all_cards = cards.map(&:card)
  end

  # for the edit card form
  def card_default?
    default_card? ? 'checked' : ''
  end

  def all_cards(user)
    user.cards.count
  end
end
