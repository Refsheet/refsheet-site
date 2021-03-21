class Media::CommentPolicy < ApplicationPolicy
  def create?
    !blocked? and !blocks?
  end
end
