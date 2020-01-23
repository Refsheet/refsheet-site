class Forum::PostPolicy < ApplicationPolicy
  def update?
    user.id == record.id || user.admin?
  end
end