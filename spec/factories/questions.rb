FactoryBot.define do
  factory :question do
    body  { Faker::Lorem.paragraph }
    title { Faker::Lorem.question }

    user

    factory :invalid_question do
      body  { nil }
      title { nil }
    end
  end
end
