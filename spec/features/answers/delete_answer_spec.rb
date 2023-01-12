require 'rails_helper'

feature 'delete answer', %q{
  In order to remove my answer 
  As user 
  I want to be able to delete answer
} do
  let!(:user)     { create(:user) }
  let!(:user2)    { create(:user) }
  let!(:question) { create(:question) }
  let!(:answer)   { create(:answer, user: user, question: question) }

  scenario 'author of answer deletes his answer', js: true do
    sign_in user
    visit question_path(question)

    within '.answers' do
      click_on 'Delete'
      
      expect(page).to_not have_content answer.body
    end
  end

  scenario 'non-author cannot see other users answers delete button' do
    sign_in user2
    visit question_path(question)

    expect(page).to_not have_content 'Delete'
  end
end
