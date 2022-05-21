require 'rails_helper'

feature 'View question answers', %q{
  In order to read answers to questions
  As user 
  I want to be able to view question's answers
} do
  let!(:question) { create(:question) }
  let!(:answers) { create_list(:answer, 5, question: question) }

  scenario 'User views question\'s answers' do
    answers.each do |answer|
      visit question_path(question)

      answers.each { |answer| expect(page).to have_content answer.body }
    end
  end
end


