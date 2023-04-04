require 'acceptance_helper'

feature 'Remove files from answer', %q{
  In order to remove unnecessary or wrong files from my answer
  As author of answer
  I want to be able to delete files
} do
  let!(:user)       { create(:user) }
  let!(:question)   { create(:question) }
  let!(:answer)     { create(:answer, question: question, user: user) }
  let!(:attachment) { create(:attachment, :for_answer, attachable: answer) }

  before do
    sign_in user

    visit question_path(question)
  end

  scenario 'author of answer delets file from his answer', js: true do
    within "#answer-#{answer.id}-attachments" do
      expect(page).to have_content attachment.file.filename

      click_on 'Delete'

      expect(page).to_not have_content attachment.file.filename
    end
  end
end
