require 'acceptance_helper'

feature 'Edit questions', %q{
  In order to fix mistakes or add details to my question
  As author of question
  I want to be able to edit question
} do
  let!(:user)          { create(:user) }
  let!(:user2)         { create(:user) }
  let!(:user_question) { create(:question, user: user, body: 'question body') }

  scenario 'Author of question edits his question' do
    sign_in user

    visit question_path(user_question)
    click_on 'Edit'
    fill_in 'Body', with: 'new body'
    click_on 'Submit'

    expect(page).to have_content 'new body'
  end

  scenario 'Non-author cannot edit question' do
    sign_in user2
    
    visit question_path(user_question)
 
    expect(page).to_not have_content 'Edit'
  end
end
