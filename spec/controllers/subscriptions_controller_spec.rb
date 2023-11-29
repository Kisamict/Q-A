require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  describe 'POST #create' do
    context 'for authenticated user' do
      before { sign_in user }

      it 'creates new subscription for user' do
        expect { post :create, params: { question_id: question.id } }.to change(user.subscriptions, :count)
      end
  
      it 'subscribes user to a requested question' do
        post :create, params: { question_id: question.id }
        expect(user.subscriptions.last.question).to eq question
      end

      it 'redirects back to question' do
        post :create, params: { question_id: question.id }
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'for unauthenticated user' do
      it 'doesnt create subscription' do
        expect { post :create, params: { question_id: question.id } }.to_not change(Subscription, :count)
      end

      it 'redirects to sign in page' do
        post :create, params: { question_id: question.id }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:subscription) { create(:subscription, user: user, question: question) }

    context 'for authenticated user' do
      before { sign_in user }

      it 'deletes users subsription' do
        expect { delete :destroy, params: { question_id: question.id, id: subscription.id } }.to change(user.subscriptions, :count).by(-1)
      end

      it 'redirects back to question' do
        delete :destroy, params: { question_id: question.id, id: subscription.id }
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'for unauthenticated user' do
      it 'doesnt delete subscription' do
        expect { delete :destroy, params: { question_id: question.id, id: subscription.id } }.to_not change(Subscription, :count)
      end

      it 'redirects to sign in page' do
        delete :destroy, params: { question_id: question.id, id: subscription.id }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
