class PublicController < ApplicationController
  skip_before_action :track_ahoy_visit
  skip_before_action :set_user_locale
  skip_before_action :set_default_meta
  skip_before_action :eager_load_session
  skip_before_action :set_raven_context

  def health
    # Ensure we have a connection to our database and that everything
    # is functioning correctly:
    counts = [User.count, Character.count, Image.count]
    render json: { status: "OK", counts: counts, version: Refsheet::VERSION }, status: 200
  rescue => _e
    head :internal_server_error
  end

  protected

  def allow_http?
    true
  end
end
