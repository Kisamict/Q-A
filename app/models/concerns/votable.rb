module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable
  end

  def vote_up(user)
    votes.create!(user: user, value: 1)
    update_rating
  end

  def vote_down(user)
    votes.create!(user: user, value: -1)
    update_rating
  end

  private

  def update_rating
    update!(rating: self.count_rating)
  end

  def count_rating
    votes.pluck(:value).sum
  end
end
