require 'rails_helper'

feature 'View each question', %q{
  In order to read question details 
  As user
  I want to be able to view individual question and its answers
} do
  let!(:answers)   { create_list(:answer, 5) }
  let!(:questions) { Question.all }

  scenario 'Users views question' do
    questions.each do |question|
      visit questions_path

      click_on question.title
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end
  end
end
