json.array!(@comments) do |comment|
  json.extract! comment, :contents, :post_id
  json.url comment_url(comment, format: :json)
end
