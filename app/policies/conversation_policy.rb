class ConversationPolicy < ApplicationPolicy
  def create?
    !blocked? and !blocks? and user.confirmed?
  end
end
