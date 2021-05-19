class Conversations::MessagePolicy < ApplicationPolicy
  def create?
    !blocked? and !blocks? and user.confirmed?
  end
end
