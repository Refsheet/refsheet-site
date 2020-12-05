class Forum::DiscussionPolicy < ApplicationPolicy
  def create?
    return true if user.admin?
    (!record.forum.locked?) && user.confirmed?
  end
end
