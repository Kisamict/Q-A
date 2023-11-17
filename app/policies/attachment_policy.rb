class AttachmentPolicy < ApplicationPolicy
  def destroy?
    user&.author_of?(record&.attachable)
  end
end
