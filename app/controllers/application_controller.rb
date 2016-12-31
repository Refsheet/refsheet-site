class ApplicationController < ActionController::Base
  include SessionHelper

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
end
