class Api::ApiController < ::ApiController
  skip_before_action :authenticate_from_token, only: [:documentation]
  skip_before_action :force_json, only: [:documentation]

  def documentation
    render layout: 'static'
  end
end