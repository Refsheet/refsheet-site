class Media::FavoritesController < ApplicationController
  before_action :get_media
  before_action :get_favorite, only: [:destroy]

  respond_to :json

  def index
    @favorites = @media.favorites
    respond_with @favorites, location: nil, serializer: Media::FavoriteSerializer
  end

  def create
    @favorite = Media::Favorite.create media: @media, user: current_user
    respond_with @favorite, location: nil, serializer: Media::FavoriteSerializer
  end

  def destroy
    @favorite.destroy
    respond_with @favorite, location: nil
  end

  private

  def get_media
    @media = Image.find_by! guid: params[:media_id]
  end

  def get_favorite
    @favorite = @media.favorites.find_by! user: current_user
  end
end
