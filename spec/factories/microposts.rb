FactoryBot.define do
  factory :micropost do
    content { 'つぶやきサンプル' }
    association :user
  end
end
