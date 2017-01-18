class Webhooks::PatreonController < ApplicationController
  def create
    Rails.logger.tagged 'PATREON' do
      Rails.logger.info create_params.as_json
      Patreon::Pledge.find_or_initialize_by(patreon_id: pledge_params[:patreon_id]).update_attributes(create_params)
    end

    head :ok
  end

  private

  def create_params
    patron = Patreon::Patron.find_or_initialize_by(patreon_id: patron_params[:patreon_id])
    patron.update_attributes(patron_params)

    reward = Patreon::Reward.find_or_initialize_by(patreon_id: reward_params[:patreon_id])
    reward.update_attributes(reward_params)

    pledge_params.merge(
        patron: patron,
        reward: reward
    )
  end

  def pledge_params
    params.require(:data).require(:attributes).permit(
        :amount_cents,
        :created_at,
        :declined_since,
        :patron_pays_fees,
        :pledge_cap_cents
    ).merge(
        :patreon_id => params[:data][:id]
    )
  end

  def patron_params
    patron_id = params[:data][:relationships][:patron][:data][:id]

    patron = params[:included].find do |incl|
      incl[:type] = 'user' && incl[:id] == patron_id
    end

    patron[:attributes].permit(
        :email,
        :full_name,
        :image_url,
        :is_deleted,
        :is_nuked,
        :is_suspended,
        :status,
        :thumb_url,
        :twitch,
        :twitter,
        :url,
        :vanity,
        :youtube
    ).merge(
        :patreon_id => patron_id
    )
  end

  def reward_params
    reward_id = params[:data][:relationships][:reward][:data][:id]

    reward = params[:included].find do |incl|
      incl[:type] = 'reward' && incl[:id] == reward_id
    end

    reward[:attributes].permit(
        :amount_cents,
        :created_at,
        :description,
        :image_url,
        :requires_shipping,
        :title,
        :url
    ).merge(
        :patreon_id => reward_id
    )
  end
end
