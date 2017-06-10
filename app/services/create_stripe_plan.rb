class CreateStripePlan
  def self.call(options={})
    plan = Plan.new(options)
    # debugger
    if !plan.valid?
      return plan
    end

    begin
      Stripe::Plan.create(
        id: options[:stripe_id],
        amount: plan.amount,
        currency: 'usd',
        interval: options[:interval],
        name: options[:name],
        # descriptor will prepend SP to the name.
        # max chars is 25 or will fail - check plan.rb for validation
        statement_descriptor: 'SP ' + options[:name],
      )
    rescue Stripe::StripeError => e
      plan.errors[:base] << e.message
    end

    plan.save!
    return plan
  end
end
