class Media::FolderPolicy < ApplicationPolicy
  def create?
    logged_in? && record.character&.managed_by?(user)
  end
end
