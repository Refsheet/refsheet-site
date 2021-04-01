class ApplicationController < ActionController::Base
  include ApplicationHelper
  include SessionHelper
  include CollectionHelper
  include ResponseHelper
  include ParamsHelper
  include Pundit

  class Unauthorized < RuntimeError; end

  serialization_scope :view_context

  respond_to :json, :html

  #== Global Hooks

  before_action :set_user_locale
  before_action :set_default_meta
  before_action :eager_load_session
  before_action :set_raven_context
  protect_from_forgery with: :exception

  around_action :tag_logs


  #== Force SSL

  def self.force_ssl(options = {})
    return unless Rails.env.production?

    before_action(options) do
      unless request.ssl? or allow_http?
        new = "https://#{request.host_with_port}#{request.fullpath}"
        redirect_to new, status: :moved_permanently
      end
    end
  end

  force_ssl


  #== Action Locks

  def self.in_beta!
    before_action do
      unless signed_in? and current_user.patron?
        raise ApplicationController::Unauthorized, 'This is available to Patrons only!'
      end
    end
  end


  #== Serialization Help

  serialization_scope :view_context


  #== Error Handling

  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActiveStorage::FileNotFoundError, with: :not_found
  rescue_from ActionController::UnknownFormat, with: :not_found
  rescue_from ActionController::InvalidAuthenticityToken, with: :bad_request
  rescue_from ActionController::ParameterMissing, with: :bad_request
  rescue_from Pundit::NotAuthorizedError, with: :unauthorized
  rescue_from ApplicationController::Unauthorized, with: :unauthorized
  rescue_from ActiveRecord::ConnectionTimeoutError, with: :thread_dump

  unless Rails.env.development?
    rescue_from ActionController::RoutingError, with: :not_found
  end


  #== Published Base Routes

  def authorize!(user=current_user)
    ActiveSupport::Deprecation.warn("Old authorize! used, please use Pundit.")
    unauthorized! unless user
  end

  def unauthorized!
    raise ApplicationController::Unauthorized.new 'You are not authorized to do that.'
  end

  def not_found!
    raise ActionController::RoutingError.new 'Whatever you just did, please do not.'
  end

  def bad_request!
    raise "This is a bad error."
  end


  #== Other Helpers

  def render_asset_paths
    {
        notificationSoundPaths: [
            view_context.asset_url('woo.mp3')
        ]
    }
  end

  helper_method :render_asset_paths

  protected

  def allow_http?
    false
  end

  def not_found(e)
    respond_to do |format|
      format.html do
        eager_load error: e.message
        render 'application/show', flash: { error: e.message }, status: :not_found
      end

      format.json { render json: { error: e.message }, status: :not_found }
      format.any  { head :not_found }
    end
  end

  def bad_request(e)
    respond_to do |format|
      format.html do
        eager_load error: e.message
        render 'application/show', flash: { error: e.message }, status: :bad_request
      end

      format.json { render json: { error: e.message }, status: :bad_request }
      format.any  { head :bad_request }
    end
  end

  def unauthorized(e=nil)
    message = e&.message || "You are not authorized to do that."

    respond_to do |format|
      format.html do
        eager_load error: message
        render 'application/show', flash: { error: message }, status: :unauthorized
      end

      format.json { render json: { error: message }, status: :unauthorized }
      format.any  { head :unauthorized }
    end
  end

  private

  def set_user_locale
    session[:locale]   = params[:locale] if params.include? :locale
    session[:locale] ||= current_user.settings(:view).locale if signed_in?
    session[:locale] ||= I18n.default_locale
    cookies[:locale]   = session[:locale]
    I18n.locale = session[:locale]

    Time.zone   = current_user.settings(:view).time_zone if signed_in?
    Time.zone ||= Application.config.time_zone

    # Fun Things
    if params[:jokes] == "off"
      @no_fun = true
    end

    if params[:jokes] == "force"
      @force_fun = true
    end
  end

  def eager_load_session
    Rails.logger.tagged "eager_load_session" do
      eager_load session: session_hash
    end
  end

  def set_default_meta
    site = 'Refsheet.net'
    desc = 'Easily create and share reference sheets and art galleries for all your characters; perfect for artists, world builders, and role players.'

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

  def set_raven_context
    Raven.extra_context(
        params: params.to_unsafe_h,
        url: request.url
    )

    Raven.breadcrumbs.record do |crumb|
      crumb.category = "Request"
      crumb.level = :info

      crumb.data = {
          controller: params[:controller],
          action: params[:action],
          url: request.url
      }
    end
  end

  def thread_dump(e)
    Rails.logger.error "listing #{Thread.list.count} threads:"

    thread_data = {
        thread_count: Thread.list.count
    }

    Thread.list.each_with_index do |t,i|
      Rails.logger.error "---- thread #{i}: #{t.inspect}"
      Rails.logger.error t.backtrace.take(5)

      thread_data["thread_#{i}"] = {
          thread: t.inspect,
          backtrace: t.backtrace.take(5)
      }
    end

    Raven.capture_exception(e, {
        extra: thread_data
    })
  end

  def tag_logs(&block)
    if defined? Google
      Google::Cloud::Trace.in_span("#{params[:controller]}##{params[:action]}") do
        Rails.logger.tagged("#{params[:controller]}##{params[:action]}", &block)
      end
    else
      Rails.logger.tagged("#{params[:controller]}##{params[:action]}", &block)
    end
  end
end
