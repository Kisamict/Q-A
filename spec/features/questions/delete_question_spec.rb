require 'rails_helper'

feature 'Delete question', %q{
  In order to remove my question
  As user
  I want to be able to delete question
} do
  let!(:user)     { create(:user) }
  let!(:user2)    { create(:user) }
  let!(:question) { create(:question, user: user) }

  scenario 'author of question deletes his question' do
    sign_in user

    visit question_path(question)

    expect { click_on 'Delete' }.to change(Question, :count).by(-1)
    expect(page).to_not have_content question.title
  end
end
