class User < ApplicationRecord
  validates :first_name, :last_name, presence: true
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable, :timeoutable, password_length: 8..128

  has_many :sales
  has_many :products, through: :sales
  after_commit :assign_customer_id, on: :create
  has_paper_trail

  def full_name
    [first_name, last_name].join (' ')
  end

  def stripe_customer_set?
    stripe_customer_id?
  end

  def purchased?(product)
    purchased_products = sales.map(&:product)
    purchased_products.include?(product)
  end

  def card_on_file(card)
    all_cards = cards.map(&:card)
  end

  def card_exists?
    cards.all.count >= 1
  end

  def hidden_fields?
    card_exists? ? 'hidden' : ''
  end

  def first_time_buyer?
    card_exists? ? '' : 'hidden'
  end

  def current_period_start?
    subscriptions.current_period_start?
  end

  def stripe_sub_created?
    subscriptions.stripe_sub_created?
  end

  def current_period_end?
    subscriptions.current_period_end?
  end

  def renewal_date?
    subscriptions.renewal_date?
  end

  def cancelled_date?
    subscriptions.cancelled_date?
  end

  def has_access?
    subscriptions.current_period_end >= Time.now
  end

  def in_grace?
    subscriptions.in_grace?
  end
  
  private

  def assign_customer_id
    customer = CreateStripeUser.call(self)
  end
end
