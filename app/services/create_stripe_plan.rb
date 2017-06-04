class CreateStripePlan
  def self.call(options={})
    plan = Plan.new(options)

    if !plan.valid?
      return plan
    end

    begin
      Stripe::Plan.create(
        id: options[:stripe_id],
        amount: options[:amount],
        currency: 'usd',
        interval: options[:interval],
        name: options[:name],
        statement_descriptor: 'DTFX ' + options[:name],
      )
    rescue Stripe::StripeError => e
      plan.errors[:base] << e.message
    end

    plan.save
    return plan
  end
end
