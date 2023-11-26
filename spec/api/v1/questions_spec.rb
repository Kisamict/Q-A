require 'rails_helper'

describe 'Questions API' do
  let!(:questions) { create_list(:question, 3) }
  let(:question) { questions.first }
  let(:access_token) { create(:access_token) } 

  describe 'GET /index' do
    let(:request_url) { '/api/v1/questions.json' }

    def do_request(params = {})
      get request_url, params: params
    end
    
    context 'for unauthenticated' do
      it_behaves_like 'API Authenticable'
    end
    
    context 'for user' do
      before { get request_url, params: { access_token: access_token.token } }

      it 'returns list of questions' do
        expect(response.body).to have_json_size(3).at_path('/')
      end

      %w(id title body created_at updated_at user_id rating).each do |attr|
        it "question contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end
    end
  end

  describe 'GET /show' do
    let(:request_url) { "/api/v1/questions/#{question.id}.json" }
    
    def do_request(params = {})
      get request_url, params: params
    end

    context 'for unauthenticated' do
      it_behaves_like 'API Authenticable'
    end

    context 'for user' do
      let!(:comment) { create(:comment, :for_question, commentable: question) }
      let!(:attachment) { create(:attachment, :for_question, attachable: question) }

      before { get request_url, params: { access_token: access_token.token } }
  
      it 'returns requested question' do
        expect(response.body).to be_json_eql(question.id.to_json).at_path('id')
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

      context 'attachments' do
        it_behaves_like 'API Attachable'
      end
    end
  end

  describe 'POST /create' do
    let(:request_url) { '/api/v1/questions.json' }

    def do_request(params = {})
      post request_url, params: params
    end

    context 'for anauthenticated' do
      it_behaves_like 'API Authenticable'
    end

    context 'for authenticated' do
      context 'with valid params' do
        let(:valid_post_request) do
          post request_url, params: {
            question: attributes_for(:question),
            access_token: access_token.token
          }
        end

        it 'creates new question' do
          expect { valid_post_request }.to change(Question, :count).by(1)
        end

        it 'returns created question with 201 status' do
          valid_post_request
          expect(response.body).to be_json_eql(Question.last.to_json(include: [:attachments, :comments]))
          expect(response.status).to eq 201
        end
        
        it 'sets token owner as question author' do
          valid_post_request
          expect(Question.last.user_id).to eq access_token.resource_owner_id
        end
      end

      context 'with invalid params' do
        let(:invalid_post_request) do
          post request_url, params: {
            question: { title: '', body: '' },
            access_token: access_token.token
          }
        end

        it 'returns 422 status' do
          invalid_post_request
          expect(response.status).to eq 422
        end

        it 'doesnt create new question' do
          expect { invalid_post_request }.to_not change(Question, :count)
        end
      end
    end
  end
end
