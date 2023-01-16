require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let!(:user)           { create(:user) }
  let!(:user2)          { create(:user) }
  let!(:questions)      { create_list(:question, 3, user: user) }
  let!(:question)       { questions.sample }
  let!(:asnwers)        { create_list(:answer, 3, question: question) }
  let!(:valid_params)   { { question: attributes_for(:question) } }
  let!(:invalid_params) { { question: attributes_for(:invalid_question) } }

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

    it 'assigns requested question answers to @answers variable' do
      expect(assigns(:answers)).to eq question.answers
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end

    it 'assigns new question\'s answer to a variable' do
      expect(assigns(:answer)).to be_a_new Answer
    end
  end

  describe 'GET #new' do
    context 'user signed in' do
      before do
        sign_in user
        get :new
      end

      it 'assigns new question to a variable' do
        expect(assigns(:question)).to be_a_new(Question)
      end

      it 'builds new question attachment' do
        expect(assigns(:question).attachments.first).to be_a_new(Attachment)
      end

      it 'renders new view' do
        expect(response).to render_template(:new)
      end
    end

    context 'user not signed in' do
      it 'redirects to sign in page' do
        get :new

        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'GET #edit' do
    before { get :edit, params: { id: question } }

    it 'assigns requested question to @question variable' do
      expect(assigns(:question)).to eq question      
    end
  end

  describe 'PATCH #update' do
    context 'user is the author of question' do
      before { sign_in user }

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

    context 'user is not the author of question' do
      before { sign_in user2 }

      it 'redirects to question page' do
        patch :update, params: { id: question, question: { title: 'New title', body: 'New body' } }

        expect(response).to redirect_to question
      end

      it 'does not updates question' do
        expect { patch :update, params: { id: question, question: { title: 'New title', body: 'New body' } } }.to_not change(question, :body)
        expect { patch :update, params: { id: question, question: { title: 'New title', body: 'New body' } } }.to_not change(question, :title)
      end
    end
  end

  describe 'POST #create' do
    context 'user authenticated' do
      before { sign_in user }

      context 'with valid params' do
        it 'creates a new question' do
          expect { post :create, params: valid_params }.to change(Question, :count).by(1)
        end
  
        it 'redirects to show view' do
          post :create, params: valid_params
          
          expect(response).to redirect_to assigns(:question)
        end

        it 'makes current user an author of created question' do
          post :create, params: valid_params

          expect(user).to be_author_of(Question.last)
        end
      end

      context 'with invalid params' do
        it 'does not create a new question' do
          expect { post :create, params: invalid_params }.to_not change(Question, :count)
        end

        it 're-renders new question view' do
          post :create, params: invalid_params

          expect(response).to render_template :new
        end
      end
    end

    context 'non-unaunthenticated user' do
      it 'does not create a new question' do
        expect { post :create, params: valid_params }.to_not change(Question, :count)
      end

      it 'redirects to sing in page' do
        post :create, params: valid_params

        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'authenticated user' do
      context 'user is the author of question' do
        before { sign_in user }
  
        it 'deletes requested question' do
          expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
        end
    
        it 'renders index view' do
          delete :destroy, params: { id: question }
          expect(response).to redirect_to questions_path
        end
      end
  
      context 'user2 is not the author of question' do
        before { sign_in user2 }
  
        it 'doesn\'t delete requested question' do
          expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
        end
  
        it 'renders index view' do
          post :destroy, params: { id: question }
          expect(response).to redirect_to questions_path
        end
      end
    end

    context 'unaunthenticated user' do
      it 'does not delete question' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end

      it 'redirects to sign in page' do
        delete :destroy, params: { id: question }
        
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
