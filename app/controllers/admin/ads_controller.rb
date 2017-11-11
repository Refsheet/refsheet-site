class Admin::AdsController < AdminController
  def index
    @ad ||= Advertisement::Campaign.new
    @ads = Advertisement::Campaign.all
    @slots = Advertisement::Slot.all
  end

  def create
    @ad = Advertisement::Campaign.create ad_params
    index
    respond_with @ad, location: admin_ads_path, action: :index
  end

  def update
    @ad = Advertisement::Campaign.find_by! guid: params[:id]

    if params[:assign]
      Advertisement::Slot.add 1

      if @ad.assign
        flash[:notice] = 'ad assigned'
      else
        flash.now[:error] = 'bad juju, make slots'
      end
    end

    respond_with @ad, location: admin_ads_path, action: :index
  end

  private

  def ad_params
    params.require(:advertisement_campaign)
        .permit(
            :title,
            :caption,
            :link,
            :image
        )
  end
end
