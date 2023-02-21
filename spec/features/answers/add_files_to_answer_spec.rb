require 'acceptance_helper'

feature 'Add files to answer', %q{
  In order to illustrate my answer
  As author of answer
  I want to be able to attach file
} do
  let!(:user)     { create(:user) }
  let!(:question) { create(:question) }

  background do
    sign_in user
    visit question_path(question)
  end

  scenario 'authenticated user creates answer with attachment', js: true do
    fill_in 'Body', with: 'New answer body'
    attach_file 'File', "#{Rails.root}/spec/fixtures/test_file.txt"

    click_on 'Submit'

    within '.answers' do
      expect(page).to have_content 'test_file.txt'
    end
  end
end
