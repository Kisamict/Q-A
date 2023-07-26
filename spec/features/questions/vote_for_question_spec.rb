require 'rails_helper'

feature 'Vote up for question', %q{
  In order to show that i like the question
  As authenticated user
  I want to be able to vote up for question
} do
  let!(:user)          { create(:user) }
  let!(:question)      { create(:question) }
  let!(:user_question) { create(:question, user: user) }
  let!(:votes)         { create_list(:vote, 3, :for_question, votable: question) }

  before { question.update!(rating: 3) }

  context 'Unauthenticated user' do
    before { visit question_path(question) }

    scenario 'cannot vote for question' do
      within '.question' do
        expect(page).to_not have_link 'Vote up'
        expect(page).to_not have_link 'Vote down'
      end
    end
    
    scenario 'can see question\s rating' do
      within "#question-#{question.id}-rating" do
        expect(page).to have_text 'Rating: 3'
      end
    end
  end

  context 'Authenticated user' do
    before { sign_in user }
    
    scenario 'can vote up for question', js: true do
      visit question_path(question)

      within '.question' do
        click_link 'Vote up'
        
        within "#question-#{question.id}-rating" do
          expect(page).to have_text 'Rating: 4'
        end
      end
    end

    scenario 'can vote down for question', js: true do
      visit question_path(question)
      
      within '.question' do
        click_link 'Vote down'
        
        within "#question-#{question.id}-rating" do
          expect(page).to have_text 'Rating: 2'
        end
      end
    end
  end

  context 'Author of question' do
    scenario 'cannot vote for own question' do
      visit question_path(user_question)
  
      within '.question' do
        expect(page).to_not have_link 'Vote up'
      end
    end
  end


  # scenario 'user cannot vote for same question twice' do
  #   pending
  # end

  # scenario 'user can rewote' do
  #   pending
  # end
end
