class ImagePolicy < ApplicationPolicy
  UNCONFIRMED_IMAGE_QUOTA = 5
  FREE_ACCOUNT_IMAGE_QUOTA = 100

  def create?
    record.managed_by?(user) or admin?
  end

  def show?
    !hidden? or record.managed_by?(user) or admin?
  end

  def create?
    record.character.managed_by?(user) or admin?
  end

  def update?
    record.managed_by?(user) or admin?
  end

  def full?
    update?
  end

  def destroy?
    update?
  end
end
