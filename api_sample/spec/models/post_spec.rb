# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  content    :string           not null
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

# spec/models/post_spec.rb
require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:user) { create(:user) }

  it 'is valid with valid attributes' do
    post = Post.new(content: 'テスト投稿', user:)
    expect(post).to be_valid
  end

  it 'is invalid without content' do
    post = Post.new(content: '', user:)
    expect(post).not_to be_valid
    expect(post.errors[:content]).to be_present
  end

  it 'is invalid without a user' do
    post = Post.new(content: 'ユーザーなし')
    expect(post).not_to be_valid
    expect(post.errors[:user]).to be_present
  end
end
