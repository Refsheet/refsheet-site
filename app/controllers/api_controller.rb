class ApiController < ApplicationController
  include Pundit

  serialization_scope :current_user

  before_action :force_json
  before_action :authenticate_from_token
  after_action :skip_cookies

  # Development helpers to ensure Pundit was called:
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  # Default rescues:

  rescue_from Pundit::NotAuthorizedError, with: :not_authorized!
  rescue_from ActiveRecord::RecordNotFound, with: :not_found!

  # Base error statuses for rendering:

  def not_found!(message = nil)
    render json: {
        error: message || "Not found"
    }, status: :not_found
  end

  def not_authorized!(message = nil)
    render json: {
        error: message || "You are not authorized to access this resource."
    }, status: :unauthorized
  end

  private

  def force_json
    request.format = :json
  end

  def current_user
    @current_user
  end

  def pundit_user
    @current_user
  end

  def authenticate_from_token
    guid = request.headers['X-ApiKeyId'] || params[:api_key_id]
    secret = request.headers['X-ApiKeySecret'] || params[:api_key_secret]

    if guid && secret
      api_key = ApiKey.find_by(guid: guid)

      if api_key && api_key.authenticate_secret(secret)
        @current_user = api_key.user
        response.headers['X-ApiKeyName'] = api_key.name
        return
      end
    end

    not_authorized!
  end

  def skip_cookies
    request.session_options[:skip] = true
  end
end