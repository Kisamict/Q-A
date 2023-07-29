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

  def revote(user)
    vote_to_destroy = votes.find_by(user: user)
    return false unless vote_to_destroy
  
    vote_to_destroy.destroy!
    update_rating
  end

  def already_voted?(user)
    votes.where(user: user).exists?
  end

  private

  def update_rating
    update!(rating: self.count_rating)
  end

  def count_rating
    votes.pluck(:value).sum
  end
end
