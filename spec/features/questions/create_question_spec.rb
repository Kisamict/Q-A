require 'rails_helper'

feature 'Create question', %q{
  In order to recieve answers for my question
  As user 
  I want to be able to create question
} do
  scenario 'user create a new question' do
    visit questions_path

    click_on 'Ask question'
    fill_in 'Title', with: 'New question title'
    fill_in 'Body', with: 'New question body'
    click_on 'Submit'

    expect(current_path).to eq question_path(Question.last)
    expect(page).to have_content 'New question title'
    expect(page).to have_content 'New question body'
  end
end
