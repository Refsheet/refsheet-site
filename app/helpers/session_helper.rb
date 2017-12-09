module SessionHelper
  def sign_in(user)
    session[:user_id] = user.id
    session[:nsfw_ok] = !!user.settings[:nsfw_ok]
    ahoy.authenticate user
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
    if session[:user_id]
      @current_user ||= User.find_by id: session[:user_id]
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


  #== Serialization Helpers

  def session_hash
    {
        nsfw_ok: session[:nsfw_ok],
        locale: session[:locale],
        time_zone: session[:time_zone],
        current_user: signed_in? ? UserIndexSerializer.new(current_user).as_json : nil
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
