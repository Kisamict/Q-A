class AnswerPolicy < ApplicationPolicy
  def create?
    user
  end

  def new?
    false
  end

  def edit?
    false
  end

  def update?
    user&.author_of?(record)
  end

  def destroy?
    user&.author_of?(record)
  end

  def mark_best?
    user&.author_of?(record.question)    
  end
end