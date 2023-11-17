require 'rails_helper'

describe AttachmentPolicy do
  subject { AttachmentPolicy.new(user, record) }
  let(:record) { create(:attachment, :for_question) }

  context 'for guest' do
    let(:user) { nil }

    it { is_expected.to forbid_all_actions }
  end

  context 'for user' do
    let(:user) { create(:user) }

    context 'user is the author of attachable' do
      let(:record) { create(:attachment, :for_question) }
      let(:user)   { record.attachable.user }

      it { is_expected.to permit_only_actions(%i[destroy]) }
    end

    context 'user is not the author of attachable' do
      it { is_expected.to forbid_all_actions }
    end
  end
end
