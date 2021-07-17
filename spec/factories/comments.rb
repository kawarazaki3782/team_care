FactoryBot.define do
  factory :comment do
    content {"コメント"}
    association :user
    association :micropost
    association :diary
  end
end
