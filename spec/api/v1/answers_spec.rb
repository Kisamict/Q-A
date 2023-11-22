require 'rails_helper'

describe 'Answers API' do
  describe '/index' do
    let(:question) { create(:question) }
    let!(:answers)  { create_list(:answer, 3, question: question) }
  
    context 'unauthorized' do
      it 'returns anautharized' do
        get "/api/v1/questions/#{question.id}/answers.json"
        expect(response.status).to eq 401
      end

      it 'returns unathorized if access token is invalid' do
        get "/api/v1/questions/#{question.id}/answers.json", params: { access_token: '123456' }
      end
    end

    context 'for user' do
      let(:access_token) { create(:access_token) }
      let(:answer) { answers.first }

      before { get "/api/v1/questions/#{question.id}/answers.json", params: { access_token: access_token.token } }

      it 'returns list of answers for requested question' do
        expect(response.body).to have_json_size(3)
      end

      %w(id question_id user_id body rating best? created_at updated_at).each do |attr|
        it "answer contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end
    end
  end
end
