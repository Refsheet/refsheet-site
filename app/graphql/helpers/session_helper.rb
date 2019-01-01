module Helpers::SessionHelper
  def current_user
    context[:current_user]
  end

  def sign_out
    context[:sign_out].call
  end

  def sign_in(user, remember: false)
    context[:sign_in].call(user, remember: remember)
  end

  def session_hash
    context[:session].call
  end
end
