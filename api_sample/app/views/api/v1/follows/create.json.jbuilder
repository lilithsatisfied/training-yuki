json.message 'フォローしました'
json.followee do
  json.id @followee.id
  json.name @followee.name
end
