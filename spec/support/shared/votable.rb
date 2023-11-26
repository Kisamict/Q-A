shared_examples 'Votable' do
  let(:model) { described_class }
  let(:votable) { create(model.to_s.underscore.to_sym) }
  let(:user) { create(:user) }

  context 'voting' do
    it '#vote_up' do
      votable.vote_up(user)
      expect(votable.votes.size).to eq 1
      expect(votable.votes.where(value: 1).count).to eq 1
    end

    it '#vote_down' do
      votable.vote_down(user)
      expect(votable.votes.size).to eq 1
      expect(votable.votes.where(value: -1).count).to eq 1
    end

    it '#revote' do
      votable.vote_up(user)
      votable.revote(user)
      votable.reload.votes.each do |vote|
        expect(vote.user_id).to_not eq user.id
      end
    end
  end

  context '#already_voted?' do
    let(:other_user) { create(:user) }

    it 'returns true' do
      votable.vote_up(user)
      expect(votable.already_voted?(user)).to be_truthy
    end

    it 'returns false' do
      expect(votable.already_voted?(other_user)).to be_falsey
    end
  end
end