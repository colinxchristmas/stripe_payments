class CreateStripeCharge
  def self.call(user, charge_options={}, card_options={}, card_form_options={}, token)
    find_user = CreateStripeUser.call(user)
    card = user.cards.find_by(:id => card_form_options[:card_on_file])
    # debugger
    begin
      if find_user.present?
        if find_user.default_source.nil?
          update_user = Stripe::Customer.retrieve(user.stripe_customer_id)
          update_user.source = token
          update_user.save!
          user.cards.create(card_options)
        elsif card.nil?
          find_user.sources.create(source: token)
          find_user.save
          user.cards.create(card_options)
        end
      end

      if card.nil?
        charge = Stripe::Charge.create(
        customer: user.stripe_customer_id,
        amount: charge_options[:amount],
        description: charge_options[:description],
        currency: 'usd',
        receipt_email: user.email,
        source: user.cards.last.stripe_id
        )

      else
        charge = Stripe::Charge.create(
        customer: user.stripe_customer_id,
        amount: charge_options[:amount],
        description: charge_options[:description],
        currency: 'usd',
        receipt_email: user.email,
        source: card.stripe_id
        )
      end
    # Need to fix error handling.
    rescue Stripe::StripeError => e
      user.errors[:base] << e.message
    end
  end
end
