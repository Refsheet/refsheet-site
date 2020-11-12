class Mutations::ImageMutations < Mutations::ApplicationMutation
  before_action :get_character, only: [:create]
  before_action :get_image, only: [:update, :destroy]

  action :destroy do
    type Types::ImageType

    argument :mediaId, !types.ID
  end

  def destroy
    PgLock.new(name: 'image_rank_lock').lock do
      @image.destroy
    end

    @image
  end

  action :update do
    type Types::ImageType

    argument :mediaId, types.ID
    argument :characterId, types.ID
    argument :folder, types.String
    argument :title, types.String
    argument :caption, types.String
    argument :nsfw, types.Boolean
    argument :hidden, types.Boolean
    argument :watermark, types.Boolean
    argument :gravity, types.String
    argument :source_url, types.String
  end

  def update
    PgLock.new(name: 'image_rank_lock').lock do
      @image.update_attributes(image_params)
    end

    @image
  end

  action :create do
    type Types::ImageType

    argument :characterId, !types.ID
    argument :folder, types.String
    argument :title, types.String
    argument :nsfw, types.Boolean
    argument :key, types.String
    argument :location, types.String
  end

  def create
    PgLock.new(name: 'image_rank_lock').lock do
      @image = @character.images.create! image_params_for_upload
    end

    @image
  end

  private

  def image_params
    params.permit(:title, :nsfw, :caption, :hidden, :source_url, :watermark, :gravity)
  end

  def image_params_for_upload
    image_params
      .merge(
          image_direct_upload_url: params[:location]
      )
  end

  def get_image
    @image = Image.find_by!(guid: params[:mediaId])
    authorize! @image.character.managed_by? current_user
    @image
  end

  def get_character
    @character = Character.find_by!(guid: params[:characterId])
    authorize! @character.managed_by? current_user
    @character
  end
end
