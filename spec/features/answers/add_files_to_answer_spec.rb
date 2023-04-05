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

    fill_in 'Body', with: 'New answer body'
    attach_file 'File', "#{Rails.root}/spec/fixtures/test_file.txt"
  end

  scenario 'authenticated user creates answer with attachment', js: true do
    click_on 'Submit'

    within '.answers' do
      expect(page).to have_content 'test_file.txt'
    end
  end

  scenario 'authenticated user creates answer with multiple attachments', js: true do
    click_on 'add file'

    all('input[type="file"]').each do |file_field|
      next if file_field.value.present? 
      
      file_field.attach_file("#{Rails.root}/spec/fixtures/test_file_2.txt")
    end

    click_on 'Submit'

    within '.answers' do
      expect(page).to have_content 'test_file.txt'
      expect(page).to have_content 'test_file_2.txt'
    end
  end
end
