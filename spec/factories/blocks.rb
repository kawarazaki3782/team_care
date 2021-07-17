FactoryBot.define do
  factory :block do
    association :blocker
    association :blocked
  end
end
