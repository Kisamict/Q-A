require 'rails_helper'

describe 'Profile API' do
  describe 'GET /me' do
    context 'for unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/profiles/me.json'
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get '/api/v1/profiles/me.json', params: { access_token: '1234' }
        expect(response.status).to eq 401
      end
    end

    context 'for user' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

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
end