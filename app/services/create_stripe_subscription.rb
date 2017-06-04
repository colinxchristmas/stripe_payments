class CreateStripeSubscription
  def self.call(plan, email_address, card_options={}, card_form_options={}, token)

    user = User.find_by(email: email_address)
    card = user.cards.find_by(:id => card_form_options[:card_on_file])

    subscription = Subscription.new(
      plan: plan,
      user: user
    )

    find_user = CreateStripeUser.call(user)
    begin
      stripe_sub = nil
      if find_user.present?
        if find_user.default_source.nil?
          update_user = Stripe::Customer.retrieve(user.stripe_customer_id)
          update_user.source = token
          update_user.save
          user.cards.create(card_options)
        end
      end

      if card.nil?
        customer = Stripe::Customer.retrieve(user.stripe_customer_id)
        new_card = customer.sources.create(card: token)
        new_card.save

        customer.default_source = new_card.id
        customer.save

        user.cards.create(card_options)

        swap_default_card(user.cards, user.cards.last)
      else
        customer = Stripe::Customer.retrieve(user.stripe_customer_id)
        customer.default_source = card.stripe_id
        customer.save

        swap_default_card(user.cards, card)
      end

      # charge subscription to new default source
      stripe_sub = customer.subscriptions.create(
        plan: plan.stripe_id
      )

      # set and save stripe confirmation to subscription model
      subscription.stripe_id = stripe_sub.id
      subscription.save!

    rescue Stripe::StripeError => e
      subscription.errors[:base] << e.message
    end

    return subscription
  end

  def self.swap_default_card(cards, new_default)
    cards_on_file = cards
    new_card = new_default
    cards_on_file.each do |card|
      if card.id === new_card.id
        card.default_card = true
      else
        card.default_card = false
      end
      card.save!
    end
  end
end
