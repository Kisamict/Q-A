class VotablePolicy < ApplicationPolicy
  def vote_up?
    user_can_vote?
  end

  def vote_down?
    user_can_vote?
  end

  def revote?
    user_can_vote?
  end
  
  private

  def user_can_vote?
    user && !user&.author_of?(record)
  end
end
