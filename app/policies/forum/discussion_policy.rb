class Forum::DiscussionPolicy < ApplicationPolicy
  def create?
    return true if user.admin?
    (!record.forum.locked?) && (user.confirmed? || record.forum.slug == 'support')
  end

  def update?
    return true if user.admin?
    (user.id == record.user_id) && (!record.forum.locked?)
  end

  def destroy?
    update?
  end
end
