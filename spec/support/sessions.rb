def sign_in(user)
  if defined? page
    page.set_rack_session user_id: user.id
  elsif defined? session
    session[:user_id] = user.id
  else
    raise "Session access not supported."
  end
end
