FactoryBot.define do
  factory :attachment do
    file { File.open("#{Rails.root}/spec/fixtures/test_file.txt") }
    
    trait :for_question do
      association :attachable, factory: :question
    end
  end
end
