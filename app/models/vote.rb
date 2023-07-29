class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :user_id, uniqueness: { scope: [:votable_id, :votable_type]  }
  validate :cannot_vote_for_own_votable

  private 

  def cannot_vote_for_own_votable
    return unless votable.respond_to?(:user)

    errors.add(:user, "Cannot vote for own #{votable.model_name.human}") if user == votable.user
  end
end
