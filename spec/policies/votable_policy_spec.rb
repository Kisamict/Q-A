require 'rails_helper'

describe VotablePolicy do
  subject { VotablePolicy.new(user, record) }
  let(:user) { create(:user) }

  context 'for user' do
    let(:record) { create(:question) }

    context 'when user not the author of record' do
      it { is_expected.to permit_only_actions(%i[vote_up vote_down revote]) }
    end

    context 'when user is author of record' do
      let(:record) { create(:question, user: user) }

      it { is_expected.to forbid_all_actions }
    end
  end
end