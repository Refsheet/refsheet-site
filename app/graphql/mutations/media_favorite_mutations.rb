class Mutations::MediaFavoriteMutations < Mutations::ApplicationMutation
  before_action :get_media

  action :create do
    type Types::MediaFavoriteType
    argument :mediaId, !types.ID
  end

  def create
    @favorite = Media::Favorite.create media: @media, user: context.current_user.call
  end

  action :destroy do
    type Types::MediaFavoriteType
    argument :mediaId, !types.ID
  end

  def destroy
    @favorite = @media.favorites.find_by! user: context.current_user.call
    @favorite.destroy
    @favorite
  end

  private

  def get_media
    @media = Image.find_by! guid: params[:mediaId]
  end
end