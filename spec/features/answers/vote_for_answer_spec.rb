require 'acceptance_helper'

feature 'Vote for answer', %q{
    In order to show that i like the answer
    As authenticated user
    I want to be able to vote up for answer
} do
  let!(:user)     { create(:user) }
  let!(:question) { create(:question) }
  let!(:answers)  { create_list(:answer, 3, question: question) }
  let!(:answer)   { answers.sample }
 
  context 'authenticated user' do
    before do 
      sign_in user
      visit question_path(question)
    end

    scenario 'authenticated user votes for answer', js: true do 
      within "#answer-#{answer.id}" do
        click_link 'Vote up'
        expect(page).to have_text 'Rating: 1'
      end
    end

    scenario 'can vote down for answer', js: true do
      visit question_path(question)
      
      within "#answer-#{answer.id}" do
        click_link 'Vote down'
        
        within "#answer-#{answer.id}-rating" do
          expect(page).to have_text 'Rating: -1'
        end
      end
    end

    scenario 'can revote', js: true do
      within "#answer-#{answer.id}"  do
        click_link 'Vote down'
        
        within "#answer-#{answer.id}-rating" do
          expect(page).to have_text 'Rating: -1'
        end

        expect(page).to_not have_link 'Vote down'

        click_link 'Revote'
        expect(page).to have_text 'Rating: 0'

        click_link 'Vote up'
        
        within "#answer-#{answer.id}-rating" do
          expect(page).to have_text 'Rating: 1'
        end

        expect(page).to_not have_link 'Vote up'
      end
    end
  end

  context 'unauthenticated user' do
    scenario 'unauthenticated user cannot vote for answers' do
      sign_out user
      visit question_path(question)
  
      within "#answer-#{answer.id}" do
        expect(page).to_not have_link 'Vote up'
      end
    end
  end

  context 'user is the author of answer' do
    let!(:user_answer) { create(:answer, user: user, question: question) }

    before do 
      sign_in user
      visit question_path(question)
    end

    scenario 'author cannot vote for own answer' do
      within "#answer-#{user_answer.id}" do
        expect(page).to_not have_link 'Vote up'
      end
    end
  end
end
