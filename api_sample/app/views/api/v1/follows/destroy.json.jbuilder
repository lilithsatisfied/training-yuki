json.message 'フォロー解除しました'
json.followee do
  json.id @followee.id
  json.name @followee.name
end
