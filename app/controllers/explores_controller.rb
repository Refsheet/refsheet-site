class ExploresController < ApplicationController
  def show
    @media = filter_scope get_scope

    render api_collection_response @media, each_serializer: ImageSerializer, include: 'character', root: 'media'
  end

  def popular
    @media = filter_scope get_scope
                              .left_joins(:favorites)
                              .group(:id)
                              .where('media_favorites.created_at' => 1.week.ago..Time.zone.now),
                          'COUNT(media_favorites.id)'

    render api_collection_response @media, each_serializer: ImageSerializer, include: 'character', root: 'media'
  end

  def favorites
    return head :unauthorized unless signed_in?

    @media = filter_scope get_scope(current_user.favorite_media),
                          'media_favorites.created_at'

    render api_collection_response @media, each_serializer: ImageSerializer, include: 'character', root: 'media'
  end

  private

  def get_scope(scope=Image)
    scope = scope.includes(:favorites, :character => [ :featured_image, :user, :profile_image, :character_groups, :color_scheme ])
    scope = scope.visible_to current_user
    scope = scope.sfw unless nsfw_on?
    scope = scope.processed
    scope
  end
end
