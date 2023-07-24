require 'rails_helper'

feature 'Vote up for question', %q{
  In order to show that i like the question
  As authenticated user
  I want to be able to vote up for question
} do
  let!(:user)     { create(:user) }
  let!(:question) { create(:question) }
  let!(:votes)    { create_list(:vote, 3, :for_question, votable: question) }

  before do
    question.update!(rating: 3)
    
    sign_in user
    visit question_path(question)
  end

  scenario 'any user can see question\s rating' do
    within "#question-#{question.id}-rating" do
      expect(page).to have_text 'Rating: 3'
    end
  end

  scenario 'authenticated user can vote for question', js: true do
    within '.question' do
      click_on 'Vote up'

      within "#question-#{question.id}-rating" do
        expect(page).to have_text 'Rating: 4'
      end
    end
  end

  scenario 'unauthenticated user cannot vote for question' do
    pending
  end

  scenario 'author of question cannot vote for his question' do
    pending
  end

  scenario 'user cannot vote for same question twice' do
    pending
  end

  scenario 'user can rewote' do
    pending
  end
end
