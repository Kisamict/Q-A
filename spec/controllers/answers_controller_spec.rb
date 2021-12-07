require 'rails_helper'

RSpec.describe AnswersController, type: :controller do  
  describe 'POST #create' do
    let!(:question) { create(:question) }

    it 'create a new answer' do
      expect { post :create, params: { answer: attributes_for(:answer), question_id: question } }.to change(question.answers, :count).by(1)
    end

    it 'renders index view' do
      post :create, params: { answer: attributes_for(:answer), question_id: question } 

      expect(response).to redirect_to assigns(:answer)
    end
  end
end
