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
FactoryBot.define do
  factory :comment do
    content { Faker::Lorem.sentence(word_count: 5) } # Fakerを使用してランダムな文を生成
    association :user  # userファクトリーを自動的に作成して関連付け
    association :post  # postファクトリーを自動的に作成して関連付け
  end
end
