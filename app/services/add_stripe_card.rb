class AddStripeCard
  def self.call(user, card_params={}, address_params={}, token)
  find_user = FindStripeUser.call(user)
  
    begin
      if find_user.present?
        if card_params[:default_card] === "true"
          customer = Stripe::Customer.retrieve(user.stripe_customer_id)
          new_card_source = customer.sources.create(card: token)
          new_card_source.save

          customer.default_source = new_card_source.id
          customer.save

          card = user.cards.create(card_params)
          added_card = user.cards.last
          # might be a more elegant way to do the line below.
          address_params.merge!("card_id" => added_card.id)

          address = Address.create(address_params)

          swap_default_card(user.cards, added_card)
        else
          customer = Stripe::Customer.retrieve(user.stripe_customer_id)

          customer.sources.create(card: token)
          customer.save

          card = user.cards.create(card_params)
          added_card = user.cards.last
          address_params.merge!("card_id" => added_card.id)
          address = Address.create(address_params)
        end
      end
    # Need to fix error handling.
    rescue Stripe::StripeError => e
      card.errors[:base] << e.message
    end

    card
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
