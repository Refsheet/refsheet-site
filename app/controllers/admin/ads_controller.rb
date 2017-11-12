class Admin::AdsController < AdminController
  before_action :get_ad, only: [:edit, :update]

  def index
    @ads = Advertisement::Campaign.all.order(total_impressions: :desc)
    @slots = Advertisement::Slot.all.impression_order
  end

  def edit
  end

  def new
    @ad = Advertisement::Campaign.new
  end

  def create
    @ad = Advertisement::Campaign.create ad_params
    respond_with @ad, location: admin_ads_path
  end

  def update
    if params[:advertisement_campaign]
      @ad.update_attributes ad_params
    elsif params[:assign]
      if Advertisement::Slot.assign @ad
        flash[:notice] = 'Advertisement is now love!'
      else
        flash.now[:error] = 'You probably didn\'t have enough slots to fill.'
      end
    end

    respond_with @ad, location: admin_ads_path
  end

  private

  def get_ad
    @ad = Advertisement::Campaign.find_by! guid: params[:id]
  end

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
