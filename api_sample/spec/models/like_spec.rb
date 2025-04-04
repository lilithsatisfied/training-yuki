# == Schema Information
#
# Table name: likes
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  post_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Like, type: :model do
  let(:user) { create(:user) }
  let(:post_record) { create(:post, user:) }

  it 'is valid with valid attributes' do
    like = Like.new(user:, post: post_record)
    expect(like).to be_valid
  end

  it 'is invalid without a user' do
    like = Like.new(post: post_record)
    expect(like).not_to be_valid
    expect(like.errors[:user]).to be_present
  end

  it 'is invalid without a post' do
    like = Like.new(user:)
    expect(like).not_to be_valid
    expect(like.errors[:post]).to be_present
  end

  it 'does not allow duplicate likes by the same user' do
    Like.create!(user:, post: post_record)
    duplicate = Like.new(user:, post: post_record)
    expect(duplicate).not_to be_valid
    expect(duplicate.errors[:post_id]).to include('has already been taken')
  end

  it 'belongs to user and post' do
    expect(described_class.reflect_on_association(:user).macro).to eq(:belongs_to)
    expect(described_class.reflect_on_association(:post).macro).to eq(:belongs_to)
  end
end
