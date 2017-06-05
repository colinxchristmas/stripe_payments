class CreateStripeCharge
  def self.call(user, charge_options={}, card_options={}, card_form_options={}, token)
    find_user = CreateStripeUser.call(user)
    card = user.cards.find_by(:id => card_form_options[:card_on_file])
    
    begin
      if find_user.present?
        if find_user.default_source.nil?
          update_user = Stripe::Customer.retrieve(user.stripe_customer_id)
          update_user.source = token
          update_user.save
          user.cards.create(card_options)
        elsif card.nil?
          find_user.sources.create(source: token)
          find_user.save
          user.cards.create(card_options)
        end
      end

      if card.nil?
        # if there isn't a saved card make the last card default
        # regardless of whether it was checked or not.
        set_default_card = user.cards.last
        set_default_card.default_card = true
        set_default_card.save!

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

    # Can't send back user object as it will break the Sales creation in controller
    # Probably need a work around at some point.
  end
end
