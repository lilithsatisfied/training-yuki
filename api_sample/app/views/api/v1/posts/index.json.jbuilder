json.array!(@posts) do |post|
  json.id post.id
  json.content post.content
  json.user_name post.user.name
end
