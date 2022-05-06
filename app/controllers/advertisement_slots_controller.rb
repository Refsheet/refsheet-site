class AdvertisementSlotsController < ApplicationController
  def next
    slot = Advertisement::Slot.next!

    @ad = slot.active_campaign
    @ad.current_slot_id = slot.id

    render json: @ad, serializer: Advertisement::CampaignSerializer
  end

  def shortcode
    @ad = Advertisement::Campaign.find_by! guid: params[:id]

    # ahoy.track 'advertisement.click',
    #            advertisement_id: @ad.guid

    redirect_to @ad.generate_link
  end
end
