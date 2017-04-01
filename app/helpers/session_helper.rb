module SessionHelper
  def sign_in(user)
    session[:user_id] = user.id
    session[:nsfw_ok] = !!user.settings[:nsfw_ok]
    @current_user = user
  end

  def sign_out
    session.delete :user_id
    session.delete :nsfw_ok
    @current_user = nil
  end

  def signed_in?
    current_user.present?
  end

  def current_user
    @current_user ||= User.find_by id: session[:user_id]
  end

  def nsfw_on?
    signed_in? && !!session[:nsfw_ok]
  end

  def nsfw_on!
    if signed_in?
      s = current_user.settings.merge(nsfw_ok: true)
      current_user.update_attributes settings: s
    end

    session[:nsfw_ok] = true
  end

  def nsfw_off!
    if signed_in?
      s = current_user.settings.merge(nsfw_ok: false)
      current_user.update_attributes settings: s
    end

    session[:nsfw_ok] = false
  end
end
