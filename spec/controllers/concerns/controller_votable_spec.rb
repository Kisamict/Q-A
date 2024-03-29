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
    end

    context 'user is the author of votable' do
      before do
        sign_in user
        subject.update(user: user) 
      end

      it 'does not change votes count' do
        expect { post :vote_up, format: :json, params: { id: subject.id } }.to_not change(Vote, :count)
      end
    end
  end

  describe 'POST #vote_down' do
    context 'unauthenticated user' do
      it 'does not create vote and nor change rating' do
        expect { post :vote_up, format: :json, params: { id: subject.id } }
          .to change(subject.votes, :count).by(0)
            .and change(subject, :rating).by(0)
      end
    end

    context 'authenticated user' do
      before { sign_in user }

      it 'creates a new vote with -1 value' do
        expect{ post :vote_down, format: :json, params: { id: subject.id } }
          .to change(subject.votes, :count).by(1)

        expect(subject.votes.last.value).to eq -1
      end

      it 'updates rating' do
        expect{ post :vote_down, format: :json, params: { id: subject.id } }
          .to change { subject.reload.rating }.by(-1)
      end
    end
  end

  describe 'DELETE #revote' do
    context 'authenticated user' do 
      before do
        sign_in user
        subject.vote_up(user)
      end

      it 'deletes users vote for votable' do
        expect { delete :revote, format: :json, params: { id: subject.id } }.to change(subject.votes, :count).by(-1)
      end

      it 'recounts rating' do
        expect { delete :revote, format: :json, params: { id: subject.id } }.to change{ subject.reload.rating }.by(-1)
      end
    end
  end
end
