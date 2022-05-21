require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:user)     { create(:user) }
  let!(:user2)    { create(:user) }
  let!(:question) { create(:question) }
  let!(:answer)   { create(:answer, question: question, user: user) }
  
  describe 'POST #create' do
    let!(:valid_params) { { answer: attributes_for(:answer, question_id: question.id, user_id: user.id), question_id: question.id } }

    context 'authenticated user' do
      before { sign_in user }

      it 'creates a new answer' do
        expect { post :create, params: valid_params }.to change(question.answers, :count).by(1)
      end

      it 'renders answer\'s question show view' do
        post :create, params: valid_params

        expect(response).to redirect_to question_path(assigns(:question))
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
          delete :destroy, params: valid_params

          expect(assigns(:answer)).to eq answer
        end

        it 'deletes requested answer' do
          expect { delete :destroy, params: valid_params }.to change(question.answers, :count).by(-1)
        end

        it 'redirects to answer\'s question page' do
          delete :destroy, params: valid_params

          expect(response).to redirect_to question_path(question)
        end
      end

      context 'user is not answer\'s author' do
        before { sign_in user2 }

        it 'assigns requested answer to @answer variable' do
          delete :destroy, params: valid_params

          expect(assigns(:answer)).to eq answer
        end

        it 'does not delete answer' do
          expect { delete :destroy, params: valid_params }.to_not change(Answer, :count)
        end

        it 'sets flash alert message' do
          delete :destroy, params: valid_params

          expect(flash[:alert]).to be_present
        end

        it 'redirects to questions page' do
          delete :destroy, params: valid_params

          expect(response).to redirect_to question_path(question)
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
end
