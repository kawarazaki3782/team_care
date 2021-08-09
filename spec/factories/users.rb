FactoryBot.define do
  factory :user do
    name { 'サンプル太郎' }
    sequence(:email) { |n| "tester#{n}@example.com" }
    password { 'password' }
    password_confirmation { 'password' }
    gender { '男性' }
    birthday { '1989-01-01' }
    address { '東京都' }
    long_teamcare { '介護者' }
    admin { false }
  end
end
