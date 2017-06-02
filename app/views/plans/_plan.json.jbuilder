json.extract! plan, :id, :stripe_id, :name, :description, :amount, :interval, :published, :created_at, :updated_at
json.url plan_url(plan, format: :json)
