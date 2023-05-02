module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable
  end

  def vote_up(user)
    votes.create!(user: user, value: 1)
  end

  def vote_down(user)
    votes.create!(user: user, value: -1)
  end

  def rating
    votes.pluck(:value).sum
  end
end
