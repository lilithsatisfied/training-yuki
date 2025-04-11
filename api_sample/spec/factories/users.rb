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
FactoryBot.define do
  factory :user do
    name { Faker::Internet.unique.username(specifier: 5..20) } # より現実的なユーザー名
    password { Faker::Internet.password(min_length: 8, max_length: 20) } # ランダムなパスワード
    password_confirmation { password } # 同じパスワードを設定

    # 管理者ユーザー用のトレイト
    trait :admin do
      admin { true }
    end

    # 多数の投稿を持つユーザー用のトレイト
    trait :with_posts do
      transient do
        posts_count { 5 }
      end

      after(:create) do |user, evaluator|
        create_list(:post, evaluator.posts_count, user: user)
      end
    end
  end
end
