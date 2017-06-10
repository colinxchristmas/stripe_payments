class CreateStripeCharge
  def self.call(user, charge_options={}, card_options={}, card_form_options={}, address_params={}, token)
    find_user = CreateStripeUser.call(user)
    # card checks for card other than default card for purchase
    card = user.cards.find_by(:id => card_form_options[:card_on_file])
    
    begin
      if find_user.present?
        if find_user.default_source.nil?
          # creates Stripe card from token and saves it with Stripe Servers
          update_user = Stripe::Customer.retrieve(user.stripe_customer_id)
          update_user.source = token
          update_user.save
          # saves cards that were created from token
          user.cards.create(card_options)
          added_card = user.cards.last
          # might be a more elegant way to do the line below.
          address_params.merge!("card_id" => added_card.id)
          address = Address.create(address_params)
        elsif card.nil?
          # creates Stripe card from token but doesn't set it as default
          find_user.sources.create(source: token)
          find_user.save
          # saves cards that were created from token
          user.cards.create(card_options)
          added_card = user.cards.last
          # might be a more elegant way to do the line below.
          address_params.merge!("card_id" => added_card.id)
          address = Address.create(address_params)
        end

      end

      if card.nil?
        # if new card is used, charge the token
        # card will not be set as default.
        charge = Stripe::Charge.create(
        customer: user.stripe_customer_id,
        amount: charge_options[:amount],
        description: charge_options[:description],
        currency: 'usd',
        receipt_email: user.email,
        source: user.cards.last.stripe_id
        )
      else
        # if there is a saved card, charge it
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
    # Probably need a work around at some point but it is functional in this form.
  end
end
