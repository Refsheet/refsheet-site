class UserPolicy < ApplicationPolicy
  def index?
    admin?
  end

  def create?
    true
  end

  def show?
    admin? or (!blocked? and !blocks?)
  end

  def update?
    user === record or admin?
  end
end
