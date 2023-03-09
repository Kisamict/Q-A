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

    fill_in 'Title', with: 'New question title'
    fill_in 'Body', with: 'New question body'

    attach_file 'File', "#{Rails.root}/spec/fixtures/test_file.txt"
  end

  scenario 'User adds file to his question', js: true do
    click_on 'Submit'

    expect(page).to have_content 'test_file.txt'
  end

  scenario 'authenticated user creates question with multiple attachments', js: true do
    click_on 'add file'

    all('input[type="file"]').each do |file_field|
      next if file_field.value.present? 
      
      file_field.attach_file("#{Rails.root}/spec/fixtures/test_file_2.txt")
    end

    click_on 'Submit'

    within '.question' do
      expect(page).to have_content 'test_file.txt'
      expect(page).to have_content 'test_file_2.txt'
    end
  end
end
