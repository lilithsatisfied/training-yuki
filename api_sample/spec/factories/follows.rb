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
    # follower_idとfollowee_idは同じユーザーにならないようにする
    association :follower, factory: :user

    # followee_userを別途作成して関連付け
    transient do
      followee_user { create(:user) }
    end

    after(:build) do |follow, evaluator|
      follow.followee_id = evaluator.followee_user.id
    end
  end
end
