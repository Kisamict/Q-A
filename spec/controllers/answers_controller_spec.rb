require 'rails_helper'
require 'controllers/concerns/controller_votable_spec'

RSpec.describe AnswersController, type: :controller do
  let!(:user)     { create(:user) }
  let!(:user2)    { create(:user) }
  let!(:question) { create(:question) }
  let!(:answer)   { create(:answer, question: question, user: user) }

  it_behaves_like 'Controller Votable'

  describe 'POST #create' do
    let!(:valid_params) { { answer: attributes_for(:answer, question_id: question.id), question_id: question.id } }

    context 'authenticated user' do
      before { sign_in user }

      it 'creates a new answer' do
        expect { post :create, params: valid_params, xhr: true }.to change(question.answers, :count).by(1)
      end

      it 'makes current user an author of created answer' do
        post :create, params: valid_params, xhr: true

        expect(user).to be_author_of Answer.last
      end
    end

    context 'unaunthenticated user' do
      it 'does not create a new answer' do
        expect { post :create, params: valid_params }.to_not change(Answer, :count)
      end

      it 'redirects to sign in page' do
        post :create, params: valid_params

        expect(response).to redirect_to new_user_session_path
      end    
    end
  end

  describe 'DELETE #destroy' do
    let!(:valid_params) { { question_id: question.id, id: answer.id } }

    context 'authenticated user' do
      context 'user is a answer\'s author' do
        before { sign_in user }

        it 'assigns request answer to @answer variable' do
          delete :destroy, params: valid_params, xhr: true

          expect(assigns(:answer)).to eq answer
        end

        it 'deletes requested answer' do
          expect { delete :destroy, params: valid_params, xhr: true }.to change(question.answers, :count).by(-1)
        end

        it 'renders destroy template' do
          delete :destroy, params: valid_params, xhr: true
          
          expect(response).to render_template :destroy
        end
      end

      context 'user is not answer\'s author' do
        before { sign_in user2 }

        it 'does not delete answer' do
          expect { delete :destroy, params: valid_params, xhr: true }.to_not change(Answer, :count)
        end

        it 'sets flash alert message' do
          delete :destroy, params: valid_params, format: :js

          expect(flash[:alert]).to be_present
        end
      end
    end

    context 'unauthenticated uswer' do
      it 'does not deletes question' do
        expect { delete :destroy, params: valid_params }.to_not change(Answer, :count)
      end

      it 'redirects to sign in' do
        delete :destroy, params: valid_params
        
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'PATCH #update' do
    context 'for user' do
      context 'when user is the author of answer' do
        before do
          sign_in user
          patch :update, params: { answer: { body: 'new body' }, question_id: question, id: answer }, xhr: true 
        end
        
        it 'assigns answer to @answer variable' do
          expect(assigns(:answer)).to eq answer
        end
    
        it 'assigns question to @question variable' do
          expect(assigns(:question)).to eq question 
        end
    
        it 'updates question' do
          answer.reload
          expect(answer.body).to eq 'new body'
        end
    
        it 'renders update template' do
          expect(response).to render_template :update
        end
      end

      context 'when user is not the author of answer' do
        before do
          sign_in user2
          patch :update, params: { answer: { body: 'new body' }, question_id: question, id: answer }, xhr: true 
        end
        
        it 'sets alert flash' do
          expect(flash[:alert]).to eq 'You are not authorized to perform this action.'
        end

        it 'doesnt update question' do
          answer.reload
          expect(answer.body).to_not eq 'new body'
        end
      end
    end
  end

  describe 'PATCH, #mark_best' do
    context 'author of question' do
      let!(:question_author) { question.user }

      before do 
        sign_in question_author
        patch :mark_best, params: { id: answer }, format: :js
      end

      it 'assigns answer to @answer variable' do
        expect(assigns(:answer)).to eq answer
      end
  
      it 'changes best? attribute to true' do
        expect(answer.reload.best?).to eq true
      end

      it 'renders update template' do
        expect(response).to render_template :update
      end
    end

    context 'user is not question\'s author' do
      before do
        sign_in user2
        patch :mark_best, params: { id: answer }, format: :js
      end

      it 'assigns answer to @answer variable' do
        expect(assigns(:answer)).to eq answer
      end

      it 'does not changes best? attribute to true' do
        expect(answer.reload.best?).to be_falsey
      end
    end
  end
end
