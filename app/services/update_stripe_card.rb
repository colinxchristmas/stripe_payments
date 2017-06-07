class UpdateStripeCard
  def self.call(user, card_params={}, address_params={})
  find_user = FindStripeUser.call(user)
  card = Card.find_by(id: card_params[:id])

    begin
      customer = Stripe::Customer.retrieve(user.stripe_customer_id)
      # updates all values to stripe card object
      find_card = Card.find_by(id: card_params[:id])
      address = Address.find_by(card_id: card_params[:id])
      new_card = customer.sources.retrieve(find_card[:stripe_id])
      # card.name needs to change to card name
      new_card.name = card_params[:card_name]
      new_card.exp_month = card_params[:card_exp_month]
      new_card.exp_year = card_params[:card_exp_year]
      new_card.address_line1 = address_params[:address_line_one]

      unless address_params[:address_line_two].empty?
        new_card.address_line2 = address_params[:address_line_two]
      end

      new_card.address_city = address_params[:address_city]
      new_card.address_state = address_params[:address_state]
      new_card.address_zip = address_params[:address_zip]
      new_card.address_country = address_params[:address_country]
      new_card.save

      if card_params[:default_card] === "true"
        # If default card is checked it updates/verifies that it is
        # still the default card
        customer.default_source = card.stripe_id
        customer.save

        # if default is checked it will swap the cards in the model.
        new_default = user.cards.find_by(:stripe_id => card.stripe_id)

        swap_default_card(user.cards, new_default)
      end

      find_card.update(card_params)
      address.update(address_params)
    # Need to fix error handling.
    rescue Stripe::StripeError => e
      card.errors[:base] << e.message
    end
    # Send original card back if there's an error.
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
