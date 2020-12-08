class PublicController < ApplicationController
  skip_before_action :track_ahoy_visit
  skip_before_action :set_user_locale
  skip_before_action :set_default_meta
  skip_before_action :eager_load_session
  skip_before_action :set_raven_context

  def health
    resque_info = Resque.info rescue {}

    # Ensure we have a connection to our database and that everything
    # is functioning correctly:
    counts = {
        users: User.unscoped.count,
        characters: Character.unscoped.count,
        images: {
            total: Image.unscoped.count,
            queued: Image.processing.count
        },
        queue: {
          pending: resque_info[:pending],
          processed: resque_info[:processed],
          workers: resque_info[:workers],
          working: resque_info[:working]
        }
    }

    Rails.logger.info(Rails.logger.inspect)
    Rails.logger.info("HEALTH_CHECK", counts)

    render json: {
        status: "OK",
        counts: counts,
        version: Refsheet::VERSION
    }, status: 200
  rescue => e
    Rails.logger.error(e)
    head :internal_server_error
  end

  protected

  def allow_http?
    true
  end
end
