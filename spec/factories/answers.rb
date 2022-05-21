FactoryBot.define do
  factory :answer do
    body { Faker::Lorem.paragraph }

    user 
    question
  end
end
