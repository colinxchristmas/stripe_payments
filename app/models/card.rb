class Card < ApplicationRecord
  belongs_to :user
  has_one :address

  accepts_nested_attributes_for :address
  has_paper_trail

  validates :stripe_id, :card_last_four, :card_type, :card_exp_month, :card_exp_year, :card_name, presence: true

  def default?
    default_card? ? '*(Default)' : ''
  end

  # I believe this method is not needed.
  # Will remove in coming releases.
  def card_exists?(user)
    all_cards = user.cards.all.count
    all_cards >= 0
  end
  # I believe this method is not needed.
  # Will remove in coming releases.
  def card_on_file(card)
    all_cards = cards.map(&:card)
  end

  # for the edit card form
  def card_default?
    check = 'checked'
    default_card? ? check : ''
  end
  # I believe this method is not needed.
  # Will remove in coming releases.
  def all_cards(user)
    user.cards.count
  end

  def card_exp_combined
    [card_exp_month, card_exp_year].join (' / ')
  end
end
