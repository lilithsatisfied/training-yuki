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
FactoryBot.define do
  factory :like do
    association :user  # userファクトリーを自動的に作成して関連付け
    association :post  # postファクトリーを自動的に作成して関連付け
  end
end
