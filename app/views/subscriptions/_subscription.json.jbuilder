json.extract! subscription, :id, :stripe_id, :user_id, :plan_id, :created_at, :updated_at
json.url subscription_url(subscription, format: :json)
