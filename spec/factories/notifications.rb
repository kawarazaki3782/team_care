FactoryBot.define do
  factory :notification do
    association :diary
    association :comment
    association :micropost
  end
end
