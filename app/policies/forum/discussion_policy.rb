class Forum::DiscussionPolicy < ApplicationPolicy
  def create?
    ! record.forum.locked? or user.admin?
  end
end