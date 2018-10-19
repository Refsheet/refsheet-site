class Mutations::ImageMutations < Mutations::ApplicationMutation
  before_action :get_character

  action :create do
    type Types::ImageType

    argument :characterId, !types.String
    argument :folder, types.String
    argument :title, types.String
    argument :nsfw, types.Boolean
    argument :key, types.String
    argument :location, types.String
  end

  def create
    @character.images.create! image_params
  end

  private

  def image_params
    params.permit(:title, :nsfw)
          .merge(
              image_direct_upload_url: params[:location]
          )
  end

  def get_character
    @character = context.current_user.characters.find(params[:characterId])
  end
end
