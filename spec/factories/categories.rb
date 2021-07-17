FactoryBot.define do
  factory :category do
    association :user
    name  {"カテゴリー"}
  end
end
