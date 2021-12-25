require 'rails_helper'

feature 'View question answers', %q{
  In order to read answers to questions
  As user 
  I want to be able to view question's answers
} do
  let!(:answers) { create_list(:answer, 5) }

  scenario 'User views question and its answers' do
    answers.each do |answer|
      visit question_path(answer.question)

      expect(page).to have_content answer.body
    end
  end
end


