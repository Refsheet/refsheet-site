class ApplicationController < ActionController::Base
  include SessionHelper
  
  before_action :set_default_meta
  protect_from_forgery with: :exception

  def self.force_ssl(options = {})
    return unless Rails.env.production?

    host = options.delete(:host)
    before_filter(options) do
      unless request.ssl? or allow_http?
        redirect_options = {:protocol => 'https://', :status => :moved_permanently}
        redirect_options.merge!(:host => host) if host
        redirect_options.merge!(:params => request.query_parameters)
        redirect_to redirect_options
      end
    end
  end

  force_ssl

  protected

  def allow_http?
    false
  end

  private

  def set_default_meta
    site = 'Refsheet.net'
    desc = 'A new, convenient way to organize your character designs and art.'

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
