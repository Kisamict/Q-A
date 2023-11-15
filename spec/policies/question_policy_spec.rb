require 'rails_helper'

describe QuestionPolicy do
  subject { described_class.new(user, question) }
  let(:question) { create(:question) }

  context 'for guest' do
    let(:user) { nil }

    it { is_expected.to permit_only_actions(%i[index show]) }
  end

  context 'for user' do
    let(:user) { create(:user) }
    
    context 'when user is not the author of question' do
      it { is_expected.to permit_only_actions(%i[index show new create]) }
    end
    
    context 'when user is the author of question' do
      let(:question) { create(:question, user: user) }
      
      it { is_expected.to permit_only_actions(%i[index show new create edit update destroy]) }
    end
  end
end
