class Plan < ApplicationRecord
  validates :stripe_id, :name, uniqueness: true, presence: true
  # 23 + 2 (prepend in create_stripe_plan.rb) is dependent on a 25 char max for Stripe desc. 
  validates :description, presence: true, length: { in: 5..23 }
  validates :interval, presence: true

  validates_numericality_of :amount,
    greater_than: 49,
  message: "must be at least 50 cents"
  has_paper_trail

  def set_plan_type
    plan_type = Array['day', 'month', 'year', 'week']
    return plan_type
  end

  def is_editable(action)
    unless action == 'new'
      return true
    else
      return false
    end
  end

  def plural_month
    case self.interval
    when 'day'
      'daily'
    when 'month'
      'monthly'
    when 'year'
      'yearly'
    when 'week'
      'weekly'
    end
  end

  def price_interval
    # price = formatted_price(amount)
    [formatted_price, plural_month].join ('/')
  end

  def formatted_price
    sprintf("$%0.2f", amount / 100.0)
  end
end
