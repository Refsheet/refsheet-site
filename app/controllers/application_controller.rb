class ApplicationController < ActionController::Base
  include SessionHelper
  include CollectionHelper

  before_action :set_user_locale
  before_action :set_default_meta
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

  protected

  def allow_http?
    false
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
