# == Schema Information
#
# Table name: follows
#
#  id          :integer          not null, primary key
#  follower_id :integer          not null
#  followee_id :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'rails_helper'

RSpec.describe Follow, type: :model do
  let(:follower) { create(:user) }
  let(:followee) { create(:user) }

  it 'is valid with valid attributes' do
    follow = Follow.new(follower:, followee:)
    expect(follow).to be_valid
  end

  it 'is invalid without a follower_id' do
    follow = Follow.new(followee:)
    expect(follow).not_to be_valid
    expect(follow.errors[:follower]).to be_present
  end

  it 'is invalid without a followee_id' do
    follow = Follow.new(follower:)
    expect(follow).not_to be_valid
    expect(follow.errors[:followee]).to be_present
  end

  it 'does not allow duplicate follows' do
    Follow.create!(follower:, followee:)
    duplicate = Follow.new(follower:, followee:)
    expect(duplicate).not_to be_valid
    expect(duplicate.errors[:followee_id]).to include('has already been taken')
  end

  it 'has proper associations' do
    assoc_follower = described_class.reflect_on_association(:follower)
    assoc_followee = described_class.reflect_on_association(:followee)

    expect(assoc_follower.macro).to eq(:belongs_to)
    expect(assoc_followee.macro).to eq(:belongs_to)
  end
end
