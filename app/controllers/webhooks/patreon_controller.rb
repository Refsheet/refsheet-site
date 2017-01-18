class Webhooks::PatreonController < ApplicationController
  def create
    Rails.logger.tagged 'PATREON' do
      Rails.logger.info params.inspect
    end

    head :ok
  end
end
