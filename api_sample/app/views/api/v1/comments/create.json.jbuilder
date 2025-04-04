json.message 'コメントを投稿しました'
json.comment do
  json.id @comment.id
  json.content @comment.content
  json.user_name @comment.user.name
end
