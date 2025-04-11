# == Schema Information
#
# Table name: books
#
#  id         :integer          not null, primary key
#  title      :string
#  author     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :book do
    title { Faker::Book.unique.title } # uniqueを追加して重複を避ける
    author { Faker::Book.author }

    # 追加情報を持つトレイト
    trait :with_details do
      publisher { Faker::Book.publisher }
      genre { Faker::Book.genre }
      published_date { Faker::Date.backward(days: 3650) } # 過去10年以内
    end
  end
end
