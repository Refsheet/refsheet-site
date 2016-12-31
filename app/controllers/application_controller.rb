class ApplicationController < ActionController::Base
  include SessionHelper

  protect_from_forgery with: :exception
  force_ssl if Rails.env.production?

  protected

  def self.force_ssl(options = {})
    host = options.delete(:host)
    before_filter(options) do
      if !request.ssl? && !(respond_to?(:allow_http?) && allow_http?)
        redirect_options = {:protocol => 'https://', :status => :moved_permanently}
        redirect_options.merge!(:host => host) if host
        redirect_options.merge!(:params => request.query_parameters)
        redirect_to redirect_options
      end
    end
  end
end
