module Lodestone
  class CharacterPolicy < ApplicationPolicy
    def create?
      user && (user.supporter? || user.admin?)
    end

    def update?
      user && (
        (user.supporter? && object&.character&.managed_by?(user)) ||
        user.admin?
      )
    end

    def destroy?
      update?
    end
  end
end