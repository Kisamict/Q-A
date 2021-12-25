require 'rails_helper'

feature 'Create answer', %q{
  In order to answer the question
  As user 
  I want to be able to create answer
} do
  let!(:question) { create(:question) }
  
  scenario 'user creates question' do

    visit question_path(question)
    fill_in 'Body', with: 'New answer body'
    click_on 'Submit'

    expect(current_path).to eq question_path(question)
    expect(page).to have_content 'New answer body'
  end
end
