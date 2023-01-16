require 'acceptance_helper'

feature 'Add files', %q{
  In order to illustrate my question
  As question author
  I want to be able to add files to my question
} do
  let!(:user)     { create(:user) }

  background do
    sign_in user
    visit new_question_path
  end

  scenario 'User adds file to his question', js: true do
    fill_in 'Title', with: 'New question title'
    fill_in 'Body', with: 'New question body'

    attach_file 'File', "#{Rails.root}/spec/fixtures/test_file.txt"

    click_on 'Submit'

    expect(page).to have_content 'test_file.txt'
  end
end
