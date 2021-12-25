require 'rails_helper'

feature 'View questions list', %q{
  In order to see my and others questions 
  As user
  I want to be able to view list of all questions
} do
  let!(:questions) { create_list(:question, 5) }

  scenario 'User views all questions' do
    visit questions_path

    questions.each { |question| expect(page).to have_content question.title }
  end
end
