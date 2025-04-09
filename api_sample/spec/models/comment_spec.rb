# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  content    :string           not null
#  user_id    :integer          not null
#  post_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:user) { create(:user) }
  let(:post_record) { create(:post, user: user) }

  it 'is valid with valid attributes' do
    comment = Comment.new(content: 'This is a comment', user: user, post: post_record)
    expect(comment).to be_valid
  end

  it 'is invalid without content' do
    comment = Comment.new(content: '', user: user, post: post_record)
    expect(comment).not_to be_valid
    expect(comment.errors[:content]).to include("can't be blank")
  end

  it 'is invalid without a user' do
    comment = Comment.new(content: 'Hello', user: nil, post: post_record)
    expect(comment).not_to be_valid
    expect(comment.errors[:user]).to be_present
  end

  it 'is invalid without a post' do
    comment = Comment.new(content: 'Hello', user: user, post: nil)
    expect(comment).not_to be_valid
    expect(comment.errors[:post]).to be_present
  end

  it 'has proper associations' do
    expect(described_class.reflect_on_association(:user).macro).to eq(:belongs_to)
    expect(described_class.reflect_on_association(:post).macro).to eq(:belongs_to)
  end
end
