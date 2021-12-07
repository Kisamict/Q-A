FactoryBot.define do
  factory :question do
    body  { Faker::Lorem.paragraph }
    title { Faker::Lorem.question }

    factory :invalid_question do
      body  { nil }
      title { nil }
    end
  end
end
