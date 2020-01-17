class ApiController < ApplicationController
  before_action :force_json
  before_action :authenticate_from_token

  # Base error statuses for rendering:

  def not_found!(message = nil)
    render json: {
        error: message || "Not found"
    }, status: :not_found
  end

  def not_authorized!(message = nil)
    render json: {
        error: message || "You are not authorized to access this resource."
    }, status: :not_found
  end

  private

  def force_json
    request.format = :json
  end

  def authenticate_from_token
    guid = request.headers['X-ApiKeyId'] || params[:api_key_id]
    secret = request.headers['X-ApiKeySecret'] || params[:api_key_secret]

    if guid && secret
      api_key = ApiKey.find_by(guid: guid)

      if api_key && api_key.authenticate_secret(secret)
        @current_user = api_key.user
        return
      end
    end

    not_authorized!
  end
end