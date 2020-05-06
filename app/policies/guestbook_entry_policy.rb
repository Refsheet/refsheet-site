class GuestbookEntryPolicy < ApplicationPolicy
  # Here is where we'd hard-restrict creation on Characters.
  def create?
    !!user
  end
end