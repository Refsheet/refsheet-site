class ApplicationController < ActionController::Base
  include SessionHelper

  protect_from_forgery with: :exception
  force_ssl if Rails.env.production?
end
