json.extract! card, :id, :stripe_id, :card_name, :card_last_four, :card_type, :card_exp_month, :card_exp_year, :default_card, :=, :user_id, :created_at, :updated_at
json.url card_url(card, format: :json)
