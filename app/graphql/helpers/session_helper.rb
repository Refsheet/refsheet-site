module Helpers::SessionHelper
  def current_user
    context[:current_user]&.call
  end

  def sign_out
    context[:sign_out]&.call
  end

  def sign_in(user, remember: false)
    context[:sign_in]&.call(user, remember: remember)
  end

  def session_hash
    {
        nsfw_ok: session[:nsfw_ok],
        locale: session[:locale],
        session_id: cookies.signed[UserSession::COOKIE_SESSION_ID_NAME],
        time_zone: session[:time_zone],
        current_user: current_user
    }
  end

  def session
    context[:session]&.call
  end

  def cookies
    context[:cookies]&.call
  end
end
