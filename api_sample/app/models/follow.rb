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
class Follow < ApplicationRecord
  belongs_to :follower, class_name: 'User'
  belongs_to :followee, class_name: 'User'

  validates :follower_id, presence: true
  validates :followee_id, presence: true
  validates :followee_id, uniqueness: { scope: :follower_id }
end
