def sign_in(user)
  if defined? page
    page.set_rack_session UserSession::COOKIE_USER_ID_NAME => user.id
  elsif defined? post and not defined? controller
    post session_path, params: { user: { username: user.username, password: user.password } }
  elsif defined? session
    session[UserSession::COOKIE_USER_ID_NAME] = user.id
  else
    raise "Session access not supported."
  end
end
