class ConversationPolicy < ApplicationPolicy
  def create?
    !blocked? and !blocks?
  end
end
