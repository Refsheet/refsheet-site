class CharacterPolicy < ApplicationPolicy
  UNCONFIRMED_CHARACTER_QUOTA = 5
  FREE_ACCOUNT_CHARACTER_QUOTE = 20

  def index?
    admin?
  end

  def show?
    (!hidden? and !blocked?) or record.managed_by?(user) or admin?
  end

  def create?
    valid_user = user and (record.user_id == user.id or admin?)
    confirmation_quota = user and (user.confirmed? || user.characters.count < UNCONFIRMED_CHARACTER_QUOTA)
    valid_user && confirmation_quota
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
