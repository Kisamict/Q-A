require 'rails_helper'

shared_examples 'Controller Votable' do
  subject     { create(described_class.controller_path.classify.constantize.to_s.underscore.to_sym) }
  let!(:user) { create(:user) }
    
  describe 'POST #vote_up' do
    context 'authenticated user' do
      before { sign_in user }
      it 'creates new vote_up with value == 1 ' do
          expect { post :vote_up, format: :json, params: { id: subject.id } }.to change(subject.votes, :count).by 1

          expect(subject.votes.last.value).to eq 1 
      end
    end
    
    context 'unaunthenticated user' do
      it 'does not create new vote' do
        expect { post :vote_up, format: :json, params: { id: subject.id } }.to_not change(subject.votes, :count)
      end

      it 'returns unathorized' do
        post :vote_up, format: :json, params: { id: subject.id }
        
        expect(response.code).to eq '401'
      end
    end

    context 'user is the author of votable' do
      before { subject.update(user: user) }

      it 'does not create new vote' do
        expect { post :vote_up, format: :json, params: { id: subject.id } }.to_not change(subject.votes, :count)
      end
    end
  end
end