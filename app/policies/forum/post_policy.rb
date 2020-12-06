class Forum::PostPolicy < ApplicationPolicy
  def update?
    return true if user.admin?
    (user.id == record.user_id) && (!record.forum.locked?)
  end

  def destroy?
    update?
  end
end
