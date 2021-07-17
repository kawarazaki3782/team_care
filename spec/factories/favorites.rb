FactoryBot.define do
  factory :favorite do
    association :user
    association :micropost
    association :diary
  end
end
