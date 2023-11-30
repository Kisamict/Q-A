require 'rails_helper'

describe SubscriptionPolicy do
  subject { SubscriptionPolicy.new(user, record) }
  let(:user) { create(:user) }

  context 'for user' do
    let(:record) { create(:subscription) }

    it { is_expected.to permit_only_actions(%i[create]) }

    context 'when user already subscribed' do
      let!(:record) { create(:subscription, user: user) }

      it { is_expected.to permit_only_actions(%i[destroy]) }
    end
  end
end