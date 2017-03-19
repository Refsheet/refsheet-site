class Admin::ImagesController < AdminController
  before_action :get_image, except: [:index]

  before_action do
    @search = { path: admin_images_path }
  end

  def index
    @images = filter_scope Image.all
    @images = taper_group @images if params[:sort].to_s == 'created_at'
  end

  def show; end
  def edit; end

  def update
    if @image.update_attributes(image_params)
      Changelog.create changelog_params
    end

    respond_with :admin, @image, location: admin_image_path(@image.guid)
  end

  private

  def get_image
    @image = Image.find_by! guid: params[:id]
  end

  def image_params
    params.require(:image).permit!
  end

  def changelog_params
    {
        user: current_user,
        reason: params[:reason],
        change_data: @image.previous_changes,
        changed_image: @image
    }
  end
end
