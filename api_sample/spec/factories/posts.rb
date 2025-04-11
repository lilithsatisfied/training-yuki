# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  content    :string           not null
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :post do
    content { Faker::Lorem.paragraph(sentence_count: 2) } # Fakerを使用してランダムな文章を生成
    association :user # userファクトリーを自動的に作成して関連付け
  end
end
