FactoryBot.define do
  factory :user do
    name {"サンプル太郎"}
    sequence(:email) { |n| "tester#{n}@example.com" }
    password {"dottle-nouveau-pavilion-tights-furze"}
    password_confirmation {"dottle-nouveau-pavilion-tights-furze"}
    gender {"男性"}
    birthday {"1989-01-01"}
    address {"東京都"}
    long_teamcare {"介護者"}
 end 
end