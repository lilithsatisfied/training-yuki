# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string           not null
#  password_digest :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is valid with valid attributes' do
    expect(build(:user)).to be_valid
  end

  it 'is invalid without a name' do
    user = build(:user, name: nil)
    expect(user).not_to be_valid
  end

  it 'is invalid without a password' do
    user = build(:user, password: nil)
    expect(user).not_to be_valid
  end
end

describe '#follow!' do
  let!(:follower) { create(:user) }
  let!(:followee) { create(:user) }

  it 'creates a follow relationship' do
    expect {
      follower.follow!(followee)
    }.to change { follower.followees.count }.by(1)

    expect(follower.following?(followee)).to be true
  end
end

describe '#like! and #liking?' do
  let!(:user) { create(:user) }
  let!(:post) { create(:post, user: user) }

  it 'likes a post and checks liking' do
    expect {
      user.like!(post)
    }.to change { user.likes.count }.by(1)

    expect(user.liking?(post)).to be true
  end
end

describe '#unlike!' do
  let!(:user) { create(:user) }
  let!(:post) { create(:post, user: user) }

  it 'removes a like from a post' do
    user.like!(post)
    expect {
      user.unlike!(post)
    }.to change { user.likes.count }.by(-1)
  end
end

describe '#comment_on' do
  let!(:user) { create(:user) }
  let!(:post) { create(:post, user: user) }

  it 'creates a comment on a post' do
    expect {
      user.comment_on(post, 'Nice post!')
    }.to change { user.comments.count }.by(1)

    comment = user.comments.last
    expect(comment.content).to eq('Nice post!')
    expect(comment.post).to eq(post)
  end
end
