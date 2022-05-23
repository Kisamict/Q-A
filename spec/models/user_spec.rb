require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associtations' do
    it { should have_many(:questions).dependent(:destroy) }
    it { should have_many(:answers).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }
  end

  context '#author_of?' do
    let!(:user)      { create(:user) }
    let!(:question)  { create(:question, user: user) }
    let!(:question2) { create(:question) }

    it 'returns true' do
      expect(user).to be_author_of(question)
    end

    it 'returns false' do
      expect(user).to_not be_author_of(question2)
    end
  end
end
