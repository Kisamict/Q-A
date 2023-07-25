require 'rails_helper'

RSpec.describe Vote, type: :model do
  describe 'associations' do
    it { should belong_to :user }
    it { should belong_to :votable }
  end

  describe 'validations' do
    context '.cannot_vote_for_own_votable'
    let!(:user)     { create(:user) }
    let!(:votables) { [create(:answer, user: user), create(:question, user: user)] }

    it 'validates that author cannot vote for own votable' do
      votables.each do |votable|
        expect { votable.votes.create(user: user) }.to_not change(Vote, :count)
      end
    end
  end
end
