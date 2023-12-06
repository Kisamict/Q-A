require 'rails_helper'

RSpec.describe SearchesController, type: :controller do
  describe "GET show" do
    context "for user" do
      let(:user) { create(:user) }
      let!(:question) { create(:question, body: 'test') }

      before { sign_in user }

      it "returns question" do
        allow(ThinkingSphinx).to receive(:search).with('test').and_return([question])

        get :show, params: { search_string: 'test' }, format: :js
      end
    end
  end
end
