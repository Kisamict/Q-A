require 'rails_helper'

describe 'Answers API' do
  let(:question) { create(:question) }
  let!(:answers)  { create_list(:answer, 3, question: question) }
  let(:answer) { answers.first }
  let(:access_token) { create(:access_token) }

  describe '/index' do
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

  describe '/show' do
    context 'unauthorized' do
      it 'returns anautharized' do
        get "/api/v1/answers/#{answer.id}.json"
        expect(response.status).to eq 401
      end

      it 'returns unathorized if access token is invalid' do
        get "/api/v1/answers/#{answer.id}.json", params: { access_token: '123456' }
      end
    end

    context 'for user' do
      let!(:comments) { create_list(:comment, 3, commentable: answer) }
      let(:comment) { comments.first } 
      let!(:attachments) { create_list(:attachment, 3, attachable: answer) }
      let(:attachment) { attachments.first }

      before { get "/api/v1/answers/#{answer.id}.json", params: { access_token: access_token.token } }

      it 'returns requested answer' do
        expect(response.body).to be_json_eql(answer.id.to_json).at_path('id')
      end

      %w(id question_id user_id body rating best? created_at updated_at).each do |attr|
        it "answer contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr).to_json).at_path(attr)
        end
      end

      context 'comments' do
        it 'answer contains comments' do
          expect(response.body).to have_json_size(3).at_path('comments')
        end

        %w(id body user_id commentable_type commentable_id).each do |attr|
          it "contain #{attr} attribute" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("comments/0/#{attr}")
          end
        end
      end

      context 'attachments' do
        it 'are included in answer object' do
          expect(response.body).to have_json_size(3).at_path('attachments')
        end

        it 'contains file attribute in link format' do
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path('attachments/0/url')
        end
      end
    end
  end
end
