require 'acceptance_helper'

feature 'edit answer', %q{
  In order to fix mistakes or add details to my answer
  As author of answer
  I want to be able to edit the answer
} do
  let!(:user)        { create(:user) }
  let!(:user2)       { create(:user) }
  let!(:question)    { create(:question) }
  let!(:answers)     { create_list(:answer, 3, question: question) }
  let!(:user_answer) { create(:answer, question: question, user: user, body: 'Old Body') }
  
  scenario 'Unauthenticated user tries to edit answer' do
    visit question_path(question)

    expect(page).to_not have_link('Edit')
  end

  scenario 'Author edits his answer', js: true do
    sign_in user

    visit question_path(question)

    within "#answer-#{user_answer.id}" do
      click_on 'Edit'
      fill_in 'Body', with: 'New body'
      click_on 'Update'
      expect(page).to_not have_content 'Old Body'
      expect(page).to have_content 'New body'
      expect(page).to_not have_selector 'textarea'
    end
  end

  scenario 'Authenticated user tries to edit other user\'s question', js: true do
    sign_in(user2)

    visit question_path(question)
    
    within '.answers' do
      expect(page).to_not have_link('Edit')
    end
  end
end
