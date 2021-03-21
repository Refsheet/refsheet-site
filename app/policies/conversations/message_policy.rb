class Conversations::MessagePolicy < ApplicationPolicy
  def create?
    !blocked? and !blocks?
  end
end
