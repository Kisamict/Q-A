require 'rails_helper'

feature 'delete answer', %q{
  In order to remove my answer 
  As user 
  I want to be able to delete answer
} do
  let!(:user)     { create(:user) }
  let!(:question) { create(:question) }
  let!(:answer)   { create(:answer, user: user, question: question) }

  scenario 'author of answer deletes his answer' do
    sign_in user

    visit question_path(question)

    within '.answers' do
      expect { click_on 'Delete' }.to change(question.answers, :count).by(-1)
    end
  end
end
