FactoryBot.define do
  factory :user do
    name { "テストユーザー" }
    email { "hoge@hoge.com" }
    password { "hoge1234" }
  end
end
