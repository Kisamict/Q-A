FactoryBot.define do
  factory :question do
    body  { Faker::Lorem.paragraph }
    title { Faker::Lorem.question }
  end
end
