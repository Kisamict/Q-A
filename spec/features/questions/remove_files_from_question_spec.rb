require 'acceptance_helper'

feature 'Remove files from question', %q{
  In order to remove wrong files from my question
  As author of question
  I want to be able to delete files
} do
  let!(:user)       { create(:user) }
  let!(:question)   { create(:question, user: user) }
  let!(:attachment) { create(:attachment, :for_question, attachable: question) }

  background do
    sign_in user
    visit question_path(question)
  end

  scenario 'atuhor of question deletes question\'s attachment', js: true do
    expect(page).to have_content attachment.file.filename

    within '.question-attachments' do
      click_on 'Delete' 
      
      expect(page).to_not have_content attachment.file.filename
    end
  end
end
