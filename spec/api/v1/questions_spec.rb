require 'rails_helper'

describe 'Questions API' do
  let!(:questions) { create_list(:question, 3) }
  let(:question) { questions.first }
  let(:user) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: user.id) } 

  describe 'GET /index' do
    context 'for anauthenticated' do
      it 'returns anauthorized' do
        get '/api/v1/questions.json'
        expect(response.status).to eq 401 
      end

      it 'returns unauthorized if access_token is invalid' do
        get '/api/v1/questions.json', params: { access_token: '1234' }
        expect(response.status).to eq 401
      end
    end
    
    context 'for user' do
      before { get '/api/v1/questions.json', params: { access_token: access_token.token } }

      it 'returns list of questions' do
        expect(response.body).to be_json_eql(questions.to_json(include: :comments))
      end

      %w(id title body created_at updated_at user_id rating).each do |attr|
        it "question contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end
    end
  end

  describe '/show' do
    context 'for anauthenticated' do
      it 'returns anauthorized' do
        get "/api/v1/questions/#{question.id}.json"
        expect(response.status).to eq 401 
      end

      it 'returns unauthorized if access_token is invalid' do
        get "/api/v1/questions/#{question.id}.json", params: { access_token: '1234' }
        expect(response.status).to eq 401
      end
    end

    context 'for user' do
      let!(:comment) { create(:comment, :for_question, commentable: question) }

      before { get "/api/v1/questions/#{question.id}.json", params: { access_token: access_token.token } }
  
      it 'returns requested question' do
        expect(response.body).to be_json_eql(question.to_json(include: :comments))
      end
  
      %w(id title body created_at updated_at user_id rating).each do |attr|
        it "question contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("#{attr}")
        end
      end

      context 'comments' do
        it 'are included in question object' do
          expect(response.body).to have_json_size(1).at_path('comments')
        end

        %w(id body user_id commentable_type commentable_id).each do |attr|
          it "contain #{attr} attribute" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("comments/0/#{attr}")
          end
        end
      end
    end
  end
end
