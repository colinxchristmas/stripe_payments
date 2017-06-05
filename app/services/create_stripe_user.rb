class CreateStripeUser
  def self.call(user)
    begin
      user_found = FindStripeUser.call(user)

      if user_found.present?
        return user_found
      else
        customer = Stripe::Customer.create(
          email: user.email,
          description: 'Stripe Payment User'
        )
        user.stripe_customer_id = customer.id
        user.save!
        return customer
      end
    # Need to fix error handling.
    rescue Stripe::StripeError => e
      user.errors[:base] << e.message
    end

    user
  end

end
