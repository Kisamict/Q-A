require 'rails_helper'

describe AnswerPolicy do
  subject { AnswerPolicy.new(user, answer) }
  let(:answer) { create(:answer) }

  context 'for guest' do
    let(:user) { nil }

    it { is_expected.to forbid_all_actions }
  end

  context 'for user' do 
    let(:user) { create(:user) }

    it { is_expected.to permit_only_actions(%i[create]) }

    context 'when user is author of answer' do
      let(:answer) { create(:answer, user: user) }

        it { is_expected.to permit_only_actions(%i[create destroy update]) }
    end

    context 'when user is author of question' do
      before { answer.question.update(user: user) }

      it { is_expected.to permit_action(:mark_best) }
    end
  end
end
