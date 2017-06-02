json.extract! product, :id, :name, :price, :permalink, :description, :references, :created_at, :updated_at
json.url product_url(product, format: :json)
