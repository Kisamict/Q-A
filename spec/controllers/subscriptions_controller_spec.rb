require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let!(:question) { create(:question) }
  let(:user) { create(:user) }

  describe 'POST #create' do
    let(:post_request) { post :create, params: { question_id: question.id }, format: :js }

    context 'for authenticated user' do
      before { sign_in user }

      it 'creates new subscription for user' do
        expect { post_request }.to change(user.subscriptions, :count)
      end
  
      it 'subscribes user to a requested question' do
        post_request
        expect(user.subscriptions.last.question).to eq question
      end

      it 'returns 201' do
        post_request
        expect(response.status).to eq 201
      end
    end

    context 'for unauthenticated user' do
      it 'doesnt create subscription' do
        expect { post_request }.to_not change(Subscription, :count)
      end

      it 'returns unauthorized' do
        post_request
        expect(response.status).to eq 401
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:subscription) { create(:subscription, user: user, question: question) }
    let(:delete_request) { delete :destroy, params: { question_id: question.id, id: subscription.id }, format: :js }

    context 'for authenticated user' do
      before { sign_in user }

      it 'deletes users subsription' do
        expect { delete_request }.to change(user.subscriptions, :count).by(-1)
      end

      it 'returns 200' do
        delete_request
        expect(response.status).to eq 200
      end
    end

    context 'for unauthenticated user' do
      it 'doesnt delete subscription' do
        expect { delete_request }.to_not change(Subscription, :count)
      end

      it 'returns unauthorized' do
        delete_request
        expect(response.status).to eq 401 
      end
    end
  end
end
