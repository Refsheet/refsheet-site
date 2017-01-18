class Webhooks::PatreonController < ApplicationController
  def create
    Rails.logger.tagged 'PATREON' do
      Rails.logger.info params.as_json
    end

    head :ok
  end
end
