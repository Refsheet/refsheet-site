class ApplicationController < ActionController::Base
  include SessionHelper
  include CollectionHelper

  before_action :set_user_locale
  before_action :set_default_meta
  before_action :eager_load_session
  protect_from_forgery with: :exception

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

  serialization_scope :view_context

  protected

  def allow_http?
    false
  end

  def api_collection_response(collection, options={})
    root = options.delete :root
    results = ActiveModel::SerializableResource.new(collection, options).as_json

    { json: {
        root => results,
        '$meta' => {
            page: params[:page] || 1,
            total: collection.total_entries,
            per_page: collection.per_page,
            pages: collection.total_pages
        }
    }}
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
    desc = 'Show off reference sheets for your characters to help art commissions and share your worlds!'

    set_meta_tags(
        site: site,
        description: desc,
        reverse: true,
        separator: '|',
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
