class PublicController < ApplicationController
  skip_before_action :track_ahoy_visit, only: [:health]

  def health
    # Ensure we have a connection to our database and that everything
    # is functioning correctly:
    Role.count >= 0
    head :ok
  rescue => _e
    head :internal_server_error
  end

  protected

  def allow_http?
    true
  end
end
