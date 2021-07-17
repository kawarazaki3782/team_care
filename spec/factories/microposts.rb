FactoryBot.define do
  factory :micropost do
    content { "つぶやき" }
    association :user
  end
end