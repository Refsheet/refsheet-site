class UserPolicy < ApplicationPolicy
  def index?
    admin?
  end

  def create?
    true
  end

  def show?
    admin? or (!blocked?)
  end

  def update?
    user === record or admin?
  end

  def destroy?
    update?
  end
end
