require 'rails_helper'

describe 'Profile API' do
  let(:user) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: user.id) }
  
  describe 'GET /me' do
    it_behaves_like 'API Authenticable', { url: '/api/v1/profiles/me.json' }

    context 'for user' do
      before { get '/api/v1/profiles/me.json', params: { access_token: access_token.token } }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      %w(id email created_at updated_at).each do |attr|
        it "returns current user json with #{attr}" do
          expect(response.body).to be_json_eql(user.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      %w(password encrypted_password).each do |attr|
        it "returns current user without #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end
    end
  end

  describe 'GET #index' do
    it_behaves_like 'API Authenticable', { url: '/api/v1/profiles.json' }

    context 'for user' do
      let!(:users) { create_list(:user, 5) }

      before { get '/api/v1/profiles.json', params: { access_token: access_token.token } }

      it 'returns 200 status' do
        expect(response).to be_successful        
      end

      it 'returns all users, except current' do
        expect(response.body).to be_json_eql users.to_json
      end

      %w(id email created_at updated_at).each do |attr|
        it "contains #{attr} for each user" do
          users.each_index do |index|
            expect(response.body).to have_json_path("#{index}/#{attr}")
          end
        end
      end
    end
  end  
end
