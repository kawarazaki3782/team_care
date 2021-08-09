FactoryBot.define do
  factory :diary do
    title { 'タイトル' }
    content { '本文' }
    status  { 1 }
    association :user
  end
end
