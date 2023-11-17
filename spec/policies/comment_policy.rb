require 'rails_helper'

describe CommentPolicy do
  subject { CommentPolicy.new(user, record) }

  context 'for user' do
    let(:user) { create(:user) }
    let(:record) { Comment }

    it { is_expected.to permit_only_actions(%i[create new]) }
  end
end
