if Rails.env.development? || Rails.env.staging?
  # Set for both development testing and staging testing
  # If using a staging environment for production testing
  # Set staging.rb in environments and use test keys in .env for production testing.
  
  Rails.configuration.stripe = {
    :publishable_key => ENV['STRIPE_PUBLIC_KEY'],
    :secret_key => ENV['STRIPE_PRIVATE_KEY']
  }

  Stripe.api_key = Rails.configuration.stripe[:secret_key]


else
  Rails.configuration.stripe = {
    :publishable_key => ENV['STRIPE_PUBLIC_KEY'],
    :secret_key => ENV['STRIPE_PRIVATE_KEY']
  }

  Stripe.api_key = Rails.configuration.stripe[:secret_key]
end
