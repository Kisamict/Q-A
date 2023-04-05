  require 'rails_helper'

  RSpec.describe AttachmentsController, type: :controller do
    describe "DELETE #destroy" do
      let!(:user)         { create(:user) }
      let!(:question)     { create(:question, user: user) }
      let!(:attachment)   { create(:attachment, :for_question, attachable: question) }
      let!(:valid_params) { { id: attachment.id} }

      context 'current user is an author of attachment\'s parent' do
        before { sign_in user }

        it 'assigns requested attachment to @attachment variable' do
          delete :destroy, params: valid_params, format: :js
    
          expect(assigns(:attachment)).to eq attachment
        end

        it 'deletes requested attachment' do
          expect { delete :destroy, params: valid_params, format: :js }.to change(question.attachments, :count).by(-1)
        end

        it 'renders destroy view' do
          delete :destroy, params: valid_params, format: :js

          expect(response).to render_template(:destroy)
        end
      end

      context 'current user is not author of attachment\'s parent' do
        let!(:user_2) { create(:user) }

        before { sign_in user_2 }

        it 'assigns requested attachment to @attachment variable' do
          delete :destroy, params: valid_params, format: :js

          expect(assigns(:attachment)).to eq attachment
        end

        it 'alerts that user cannot delete this file' do
          delete :destroy, params: valid_params, format: :js

          expect(flash[:alert]).to_not be_nil
        end

        it 'doesn\'t delets requested attachment' do
          expect { delete :destroy, params: valid_params, format: :js }.to_not change(question.attachments, :count)
        end
      end

      context 'unathenticated user' do
        it 'returns 401 unathorized' do
          delete :destroy, params: valid_params, format: :js

          expect(response.code).to eq '401'
        end

        it 'doesn\'t delets requested attachment' do
          expect { delete :destroy, params: valid_params, format: :js }.to_not change(question.attachments, :count)
        end
      end
    end
  end
