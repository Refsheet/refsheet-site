module SessionHelper
  def sign_in(user, remember: true)
    session[UserSession::COOKIE_USER_ID_NAME] = user.id
    session[:nsfw_ok] = !!user.settings(:view)[:nsfw_ok]
    cookies.signed[UserSession::COOKIE_USER_ID_NAME] = user.id
    ahoy.authenticate user
    remember(user) if remember
    @current_user = user
  end

  def sign_out
    session.delete UserSession::COOKIE_USER_ID_NAME
    session.delete :nsfw_ok
    forget
    @current_user = nil
  end

  def signed_in?
    current_user.present?
  end

  def current_user
    if cookies[UserSession::COOKIE_SESSION_TOKEN_NAME]
      get_remembered_user
    end

    if (user_id = session[UserSession::COOKIE_USER_ID_NAME] ||
        (defined? cookies and cookies.signed[UserSession::COOKIE_USER_ID_NAME]))
      @current_user ||= User.find_by id: user_id
    else
      nil
    end
  end


  #== Marketplace

  def current_cart
    if session[:order_id]
      @current_cart ||= Order.find_by id: session[:order_id]
    else
      Order.new user: current_user
    end
  end

  def persist_cart!
    return if current_cart.persisted?
    session[:order_id] = current_cart.tap(&:save).id
  end

  def reset_cart!
    session.delete :order_id
    @current_cart = nil
  end


  #== NSFW

  def nsfw_on?
    signed_in? && !!session[:nsfw_ok]
  end

  def nsfw_on!
    if signed_in?
      current_user.settings(:view).update_attributes nsfw_ok: true
    end

    session[:nsfw_ok] = true
  end

  def nsfw_off!
    if signed_in?
      current_user.settings(:view).update_attributes nsfw_ok: false
    end

    session[:nsfw_ok] = false
  end


  #== Remember Me

  def remember(user)
    session = user.sessions.create
    cookies.permanent.signed[UserSession::COOKIE_SESSION_ID_NAME] = session.session_guid
    cookies.permanent.signed[UserSession::COOKIE_SESSION_TOKEN_NAME] = session.session_token
    cookies.permanent.signed[UserSession::COOKIE_USER_ID_NAME] = session.user_id
  end

  def get_remembered_user
    if cookies[UserSession::COOKIE_SESSION_ID_NAME] && cookies[UserSession::COOKIE_USER_ID_NAME]
      session = UserSession.find_by(session_guid: cookies[UserSession::COOKIE_SESSION_ID_NAME])

      if session &&
          session.user_id == cookies[UserSession::COOKIE_USER_ID_NAME] &&
          session.authenticate(cookies[UserSession::COOKIE_SESSION_TOKEN_NAME])

        sign_in(session.user, remember: false)
        return session.user
      end
    end
  end

  def forget
    cookies.delete(UserSession::COOKIE_SESSION_ID_NAME)
    cookies.delete(UserSession::COOKIE_SESSION_TOKEN_NAME)
    cookies.delete(UserSession::COOKIE_USER_ID_NAME)
  end


  #== Serialization Helpers

  def session_hash
    {
        nsfw_ok: session[:nsfw_ok],
        locale: session[:locale],
        session_id: cookies[UserSession::COOKIE_SESSION_ID_NAME],
        time_zone: session[:time_zone],
        current_user: signed_in? ? PrivateUserSerializer.new(current_user).as_json : nil
    }
  end

  def eager_load(object_or_key, resource=nil, serializer=nil)
    @eager_load ||= {}

    if object_or_key.is_a? Hash
      @eager_load.merge! object_or_key
    else
      raise ArgumentError.new 'A key is required if using key, resource params.' unless object_or_key && object_or_key.respond_to?(:to_sym)
      raise ArgumentError.new 'A resource is required if using key, resource params.' unless resource

      if serializer.nil?
        value = resource
      elsif resource.is_a? ActiveRecord::Relation
        value = ActiveModel::SerializableResource.new(resource, each_serializer: serializer, scope: view_context)
      else
        value = serializer.new(resource, scope: view_context)
      end

      value = value.as_json if value.respond_to? :as_json

      @eager_load.merge! object_or_key.to_sym => value
    end
  end
end
