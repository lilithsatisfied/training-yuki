# app/views/api/v1/posts/create.json.jbuilder
json.message '投稿を作成しました'
json.post do
  json.id @post.id
  json.content @post.content
  json.user_name @post.user.name
end
