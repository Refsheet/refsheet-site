class UserPolicy < ApplicationPolicy
  def show?
    true
  end

  def update?
    user === record or user.admin?
  end
end