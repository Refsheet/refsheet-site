class ApplicationController < ActionController::Base
  include SessionHelper
  
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
