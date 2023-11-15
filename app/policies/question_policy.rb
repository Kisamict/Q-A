class QuestionPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def new? 
    user
  end

  def create?
    user
  end

  def edit?
    user&.author_of?(record)
  end
  
  def update?
    user&.author_of?(record)
  end

  def destroy?
    user&.author_of?(record)
  end
end