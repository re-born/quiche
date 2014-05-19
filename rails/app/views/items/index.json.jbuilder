json.array!(@items) do |item|
  json.extract! item, :id, :title, :first_image_url, :user_id, :name, :content, :deleted_at
  json.url item_url(item, format: :json)
end
