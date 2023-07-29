require 'rails_helper'

feature 'Vote for question', %q{
  In order to show that i like or dislike the question
  As authenticated user
  I want to be able to vote for question
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
    before do
      sign_in user
      visit question_path(question)
    end
    
    scenario 'can vote up for question', js: true do
      within '.question' do
        click_link 'Vote up'
        
        within "#question-#{question.id}-rating" do
          expect(page).to have_text 'Rating: 4'
        end
      end
    end

    scenario 'can vote down for question', js: true do
      within '.question' do
        click_link 'Vote down'
        
        within "#question-#{question.id}-rating" do
          expect(page).to have_text 'Rating: 2'
        end
      end
    end

    scenario 'can revote', js: true do
      within '.question' do
        click_link 'Vote down'
        
        within "#question-#{question.id}-rating" do
          expect(page).to have_text 'Rating: 2'
        end

        expect(page).to_not have_link 'Vote down'

        click_link 'Revote'
        expect(page).to have_text 'Rating: 3'

        click_link 'Vote up'
        
        within "#question-#{question.id}-rating" do
          expect(page).to have_text 'Rating: 4'
        end

        expect(page).to_not have_link 'Vote up'
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
end
