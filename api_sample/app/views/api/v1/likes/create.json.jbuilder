json.message 'いいねしました'
json.post do
  json.id @post.id
  json.content @post.content
  json.user_name @post.user.name
end
