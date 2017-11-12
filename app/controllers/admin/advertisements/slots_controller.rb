class Admin::Advertisements::SlotsController < AdminController
  def create
    if params[:adjust_to]
      Advertisement::Slot.adjust_to params[:adjust_to].to_i
    end

    redirect_to admin_ads_path, flash: {
        notice: 'Ad slots adjusted.'
    }
  end
end
