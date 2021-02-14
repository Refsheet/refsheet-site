class CharacterPolicy < ApplicationPolicy
  def index?
    admin?
  end

  def show?
    (!hidden? and !blocked?) or record.managed_by?(user) or admin?
  end

  def create?
    user and (record.user_id == user.id or admin?)
  end

  def update?
    user and (record.managed_by?(user) or admin?)
  end

  def convert?
    update?
  end

  def transfer?
    update?
  end

  def destroy?
    update?
  end
end
