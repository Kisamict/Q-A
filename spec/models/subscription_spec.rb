require 'rails_helper'

RSpec.describe Subscription, type: :model do
  context 'associacions' do
    it { should belong_to :question }
    it { should belong_to :user }
  end

  context 'validations' do
    subject { build(:subscription) }

    it do
      should validate_uniqueness_of(:user_id)
        .scoped_to(:question_id)
        .with_message('Cannot subscribe for same question twice')
    end
  end
end
