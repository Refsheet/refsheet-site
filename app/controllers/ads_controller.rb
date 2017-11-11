class AdsController < ApplicationController
  def next
    slot = Advertisement::Slot.next!

    @ad = slot.active_campaign
    @ad.active_slot_id = slot.id

    render json: @ad, serializer: Advertisement::CampaignSerializer
  end
end
