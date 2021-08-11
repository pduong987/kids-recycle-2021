json.extract! listing, :id, :title, :description, :price, :status, :location, :create_at, :buyer_id, :seller_id, :profile_id, :created_at, :updated_at
json.url listing_url(listing, format: :json)
