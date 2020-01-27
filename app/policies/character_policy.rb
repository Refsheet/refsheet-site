class CharacterPolicy < ApplicationPolicy
  def show?
    !record.hidden or record.managed_by?(user) or user&.admin?
  end

  def create?
    user and (record.user_id == user.id or user.admin?)
  end

  def update?
    user and (record.managed_by?(user) or user.admin?)
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