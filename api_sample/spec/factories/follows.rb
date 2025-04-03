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
FactoryBot.define do
  factory :follow do
    follower_id { 1 }
    followee_id { 1 }
  end
end
