FactoryBot.define do
  factory :like do
    association :user
    association :micropost
    association :diary
  end
end