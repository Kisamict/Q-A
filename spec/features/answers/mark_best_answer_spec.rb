require 'acceptance_helper'

RSpec.describe feature 'mark best answer', %q{
  In order to mark question as answered 
  As author of question
  I want to able to mark best answer
} do
  let!(:author)   { create(:user) }
  let!(:non_author)   { create(:user) }
  let!(:question) { create(:question, user: author) }
  let!(:answers)  { create_list(:answer, 3, question: question) }

  scenario 'author of question marks best answer', js: true do
    sign_in author
    visit question_path(question)

    within "#answer-#{answers.last.id}" do
      click_on 'Mark best'
      
      expect(page).to have_css('.best_answer')
    end
  end

  scenario 'non-author of question cannot see Mark best button' do
    sign_in non_author
    visit question_path(question)

    expect(page).to_not have_content 'Mark best'
  end

  scenario 'author of question re-selects another answer as best', js: true do
    answers.first.best!

    sign_in author
    visit question_path(question)

    within "#answer-#{answers.last.id}" do
      click_on 'Mark best'

      expect(page).to have_css '.best_answer'
    end

    expect(page.all('.best_answer').count).to eq 1
  end
end
