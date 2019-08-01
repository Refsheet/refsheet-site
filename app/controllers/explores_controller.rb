class ExploresController < ApplicationController
  def show
    @media = filter_scope get_scope

    respond_to do |format|
      format.json { render api_collection_response @media, each_serializer: ImageSerializer, include: 'character', root: 'media' }
      format.html do
        set_meta_tags(
            title: 'Explore Images',
            description: 'Explore recent artwork uploads across all of Refsheet.net!'
        )

        eager_load media: @media

        render 'application/show'
      end
    end
  end

  def popular
    @media = filter_scope get_scope
                              .left_joins(:favorites)
                              .group(:id)
                              .where('media_favorites.created_at' => 1.week.ago..Time.zone.now),
                          'COUNT(media_favorites.id)'

    respond_to do |format|
      format.json { render api_collection_response @media, each_serializer: ImageSerializer, include: 'character', root: 'media' }
      format.html do
        set_meta_tags(
            title: 'Popular Media',
            description: 'See what\'s getting a lot of love this week on Refsheet.net!'
        )

        eager_load media: @media

        render 'application/show'
      end
    end
  end

  def favorites
    return head :unauthorized unless signed_in?

    @media = filter_scope get_scope(current_user.favorite_media),
                          'media_favorites.created_at'

    respond_to do |format|
      format.json { render api_collection_response @media, each_serializer: ImageSerializer, include: 'character', root: 'media' }
      format.html do
        set_meta_tags(
            title: 'Your Favorites',
            description: 'Everything you\'ve ever loved in one place (finally)!'
        )

        eager_load media: @media

        render 'application/show'
      end
    end
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
