class Forum::PostPolicy < ApplicationPolicy
  def index?
    admin?
  end

  def update?
    return true if admin?
    (user.id == record.user_id) && (!record.forum.locked?)
  end

  def destroy?
    update?
  end
end
