require 'rails_helper'

feature 'Create question', %q{
  In order to recieve answers for my question
  As user 
  I want to be able to create question
} do
  let!(:user) { create(:user) }

  scenario 'authenticated user creates a new question' do
    sign_in(user)
    visit questions_path

    click_on 'Ask question'
    fill_in 'Title', with: 'New question title'
    fill_in 'Body', with: 'New question body'

    expect { click_on 'Submit' }.to change(Question, :count).by(1)
    expect(current_path).to eq question_path(Question.last)
    expect(page).to have_content 'New question title'
    expect(page).to have_content 'New question body'
  end

  scenario 'authenticated user fails to create question with invalid params' do
    sign_in(user)

    visit questions_path
    click_on 'Ask question'

    fill_in 'Body', with: ''
    fill_in 'Title', with: ''
    click_on 'Submit'

    expect(page).to have_content 'Body can\'t be blank'
    expect(page).to have_content 'Title can\'t be blank'
  end

  scenario 'unauthenticated user tries to create a new question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
