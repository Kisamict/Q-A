class SubscriptionPolicy < ApplicationPolicy
def new?
  false
end

  def create?
    user && record.question.subscriptions.where(user_id: user.id).empty?
  end

  def destroy?
    record.user == user
  end
end