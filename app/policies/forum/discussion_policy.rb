class Forum::DiscussionPolicy < ApplicationPolicy
  def create?
    return true if user.admin?
    # TODO - User confirmation is hard also this error message isn't all that helpful
    (!record.forum.locked?)# && user.confirmed?
  end

  def update?
    return true if user.admin?
    (user.id == record.user_id) && (!record.forum.locked?)
  end

  def destroy?
    update?
  end
end
