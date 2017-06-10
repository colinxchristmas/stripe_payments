class FindStripeUser
  def self.call(user)
    begin
      if user.stripe_customer_id.nil?
        customer = Stripe::Customer.create(email: user.email)
        user.stripe_customer_id = customer.id
        user.save
        customer_return = Stripe::Customer.retrieve(user.stripe_customer_id)
        return customer
      else
        customer = Stripe::Customer.retrieve(user.stripe_customer_id)
        return customer
      end
    rescue Stripe::StripeError => e
      user.errors[:base] << e.message
    end

    user   
  end

end
