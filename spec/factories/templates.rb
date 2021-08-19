FactoryBot.define do
  factory :template do
    association :user
    content { 'つぶやきテンプレート' }
  end
end
