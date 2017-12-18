class ApplicationController < ActionController::Base
  include ApplicationHelper
  include SessionHelper
  include CollectionHelper
  include ResponseHelper

  serialization_scope :view_context

  respond_to :json, :html


  #== Global Hooks

  before_action :set_user_locale
  before_action :set_default_meta
  before_action :eager_load_session
  protect_from_forgery with: :exception


  #== Force SSL

  def self.force_ssl(options = {})
    return unless Rails.env.production?

    before_filter(options) do
      unless request.ssl? or allow_http?
        new = "https://#{request.host_with_port}#{request.fullpath}"
        redirect_to new, status: :moved_permanently
      end
    end
  end

  force_ssl


  #== Action Locks

  def self.in_beta!
    before_filter do
      unless signed_in? and current_user.patron?
        raise ActionController::RoutingError.new 'This is available to Patrons only!'
      end
    end
  end


  #== Serialization Help

  serialization_scope :view_context


  #== Error Handling

  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActionController::UnknownFormat, with: :not_found
  rescue_from ActionController::InvalidAuthenticityToken, with: :bad_request
  rescue_from ActionController::ParameterMissing, with: :bad_request

  unless Rails.env.development?
    rescue_from ActionController::RoutingError, with: :not_found
  end


  #== Published Base Routes

  def not_found!
    raise ActionController::RoutingError.new 'Whatever you just did, please do not.'
  end

  protected

  def allow_http?
    false
  end

  def not_found(e)
    respond_to do |format|
      format.html do
        eager_load error: e.message
        render 'application/show', flash: { error: e.message }
      end

      format.json { render json: { error: e.message }, status: :not_found }
      format.any  { head :not_found }
    end
  end

  def bad_request(e)
    respond_to do |format|
      format.html do
        eager_load error: e.message
        render 'application/show', flash: { error: e.message }
      end

      format.json { render json: { error: e.message }, status: :bad_request }
      format.any  { head :bad_request }
    end
  end

  private

  def set_user_locale
    session[:locale]   = params[:locale] if params.include? :locale
    session[:locale] ||= current_user.settings[:locale] if signed_in?
    session[:locale] ||= I18n.default_locale
    I18n.locale = session[:locale]

    Time.zone   = current_user.settings[:time_zone] if signed_in?
    Time.zone ||= Application.config.time_zone
  end

  def eager_load_session
    eager_load session: session_hash
  end

  def set_default_meta
    site = 'Refsheet.net'
    desc = 'Easily create and share reference sheets and art galleries for all your characters; perfect for artists, world builders, and role players.'

    Rails.logger.info params.inspect

    if params[:page] == :home
      site += ': Your Characters, Organized.'
    end

    set_meta_tags(
        site: site,
        description: desc,
        reverse: true,
        separator: '-',
        og: {
            title: :title,
            description: :description,
            site_name: site
        },
        twitter: {
            title: :title,
            description: :description
        }
    )
  end
end
