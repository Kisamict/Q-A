require 'acceptance_helper'

feature 'Vote for answer', %q{
    In order to show that i like the answer
    As authenticated user
    I want to be able to vote up for answer
} do
  let!(:user)     { create(:user) }
  let!(:question) { create(:question) }
  let!(:answers)  { create_list(:answer, 3, question: question, user: user) }
  let!(:answer)   { answers.sample }
 
  before do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'authenticated user votes for answer', js: true do 
    within "#answer-#{answer.id}" do
      click_link 'Vote up'
      expect(page).to have_text 'Rating: 1'
    end
  end

  scenario 'unauthenticated user cannot vote for answer' do
    sign_out user
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'Vote up'
    end
  end
end
