class ColorSchemePolicy < ApplicationPolicy
  def update?
    user && (record.user_id == user.id || user.admin?)
  end

  def create?
    !!user
  end
end