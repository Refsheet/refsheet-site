module SessionHelper
  def sign_in(user)
    session[:user_id] = user.id
    @current_user = user
  end

  def sign_out
    session.delete :user_id
    @current_user = nil
  end

  def signed_in?
    session[:user_id].present?
  end

  def current_user
    @current_user ||= User.find_by id: session[:user_id]
  end
end
