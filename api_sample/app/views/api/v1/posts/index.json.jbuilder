json.posts do
  json.array!(@posts) do |post|
    json.id post.id
    json.content post.content
    json.user_name post.user.name
  end
end

json.pagination do
  json.current_page @posts.current_page
  json.total_pages @posts.total_pages
  json.total_count @posts.total_count
  json.next_page @posts.next_page
  json.prev_page @posts.prev_page
end
