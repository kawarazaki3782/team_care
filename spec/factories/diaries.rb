FactoryBot.define do
  factory :diary do
    title {"タイトル"}
    content { "本文" }
    status  {0}
    association :user
  end
end



