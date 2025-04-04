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
class User < ApplicationRecord
  has_many :active_follows, class_name: 'Follow', foreign_key: 'follower_id', dependent: :destroy
  has_many :followees, through: :active_follows, source: :followee
  has_many :passive_follows, class_name: 'Follow', foreign_key: 'followee_id', dependent: :destroy
  has_many :followers, through: :passive_follows, source: :follower
  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post

  has_secure_password
  validates :name, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }

  def follow!(other_user)
    active_follows.create!(followee_id: other_user.id)
  end

  def following?(other_user)
    active_follows.exists?(followee_id: other_user.id)
  end

  def like!(post)
    likes.create!(post: post)
  end

  def unlike!(post)
    likes.find_by(post: post)&.destroy
  end

  def liking?(post)
    liked_posts.exists?(post.id)
  end
end
