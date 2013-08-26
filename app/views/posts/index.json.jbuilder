json.array!(@posts) do |post|
  json.extract! post, :title, :contents
  json.url post_url(post, format: :json)
end
