require 'rails_helper'

feature 'Create answer', %q{
  In order to answer the question
  As user 
  I want to be able to create answer
} do
  let!(:question) { create(:question) }
  let!(:user)     { create(:user) }
  
  scenario 'authenticated user creates answer' do
    sign_in(user)

    visit question_path(question)
    fill_in 'Body', with: 'New answer body'
    click_on 'Submit'

    expect(current_path).to eq question_path(question)
    expect(page).to have_content 'New answer body'
  end

  scenario 'authenticated user fails to create answer without body' do
    sign_in(user)

    visit question_path(question)
    fill_in 'Body', with: ''
    click_on 'Submit'

    expect(page).to have_content 'Body can\'t be blank'
  end

  scenario 'unauthenticated user tries to create a new answer' do
    visit question_path(question)
    fill_in 'Body', with: 'New answer body'

    expect { click_on 'Submit' }.to_not change(Question, :count)
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
    expect(current_path).to eq new_user_session_path
  end
end
