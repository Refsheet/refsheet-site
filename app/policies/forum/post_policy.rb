class Forum::PostPolicy < ApplicationPolicy
  def update?
    user.id == record.user_id || user.admin?
  end
end