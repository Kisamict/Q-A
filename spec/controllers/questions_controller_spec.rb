require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let!(:questions) { create_list(:question, 3) }
  let!(:question)  { questions.sample }

  describe 'GET #index' do

    before { get :index }

    it 'fills questions variable with all questions' do
      expect(assigns(:questions)).to eq(questions)
    end

    it 'renders index view' do
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns requested question to @question variable' do
      expect(assigns(:question)).to eq question
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end

    it 'assigns new question\'s answer to a variable' do
      expect(assigns(:answer)).to be_a_new Answer
      expect(assigns(:answer).question).to eq question
    end
  end

  describe 'GET #new' do
    before { get :new }

    it 'assigns new question to a variable' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template(:new)
    end
  end

  describe 'GET #edit' do
    before { get :edit, params: { id: question } }

    it 'assigns requested question to @question variable' do
      expect(assigns(:question)).to eq question      
    end
  end

  describe 'PATCH #update' do
    context 'with valid params' do
      it 'assigns requested question to @question variable' do
        patch :update, params: { id: question, question: { title: 'New title', body: 'New body' } }

        expect(assigns(:question)).to eq question
      end
  
      it 'updates question attributes' do
        patch :update, params: { id: question, question: { title: 'New title', body: 'New body' } }
        
        question.reload

        expect(question.title).to eq 'New title'
        expect(question.body).to eq 'New body'
      end

      it 'renders uploaded question view' do
        patch :update, params: { id: question, question: { title: 'New title', body: 'New body' } }

        expect(response).to redirect_to question
      end
    end

    context 'with invalid params' do
      it 'does not update question attributes' do
        patch :update, params: { id: question, question: attributes_for(:invalid_question) }
        
        question.reload

        expect(question.title).to_not eq nil
        expect(question.body).to_not eq nil
      end

      it 're-renders edit view' do
        patch :update, params: { id: question, question: attributes_for(:invalid_question) }

        expect(response).to render_template :edit
      end
      
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new question' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        
        expect(response).to redirect_to assigns(:question)
      end
    end
    
    context 'with invalid params' do
      it 'does not create a new question' do
        expect { post :create, params: { question: attributes_for(:invalid_question) } }.to_not change(Question, :count)
      end

      it 're-renders new question view' do
        post :create, params: { question: attributes_for(:invalid_question) }

        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes requested question' do
      expect { post :destroy, params: { id: question } }.to change(Question, :count).by(-1)
    end

    it 'renders index view' do
      post :destroy, params: { id: question }
      expect(response).to redirect_to questions_path
    end
  end
end
