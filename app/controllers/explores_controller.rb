class ExploresController < ApplicationController
  in_beta!

  def show
    @media = filter_scope Image

    respond_to do |format|
      format.json { render json: @media, each_serializer: CharacterImageSerializer }
      format.html do
        set_meta_tags(
            title: 'Explore',
            description: 'Explore recent artwork uploads across all of Refsheet.net!'
        )

        render 'application/show'
      end
    end
  end

  def popular
    @media = filter_scope Image
                              .left_joins(:favorites)
                              .group(:id)
                              .where('media_favorites.created_at' => 1.week.ago..Time.zone.now),
                          'COUNT(media_favorites.id)'

    respond_to do |format|
      format.json { render json: @media, each_serializer: CharacterImageSerializer }
      format.html do
        set_meta_tags(
            title: 'Popular Media',
            description: 'See what\'s getting a lot of love this week on Refsheet.net!'
        )

        render 'application/show'
      end
    end
  end

  def favorites
    head :unauthorized unless signed_in?

    @media = filter_scope current_user.favorite_media,
                          'media_favorites.created_at'

    respond_to do |format|
      format.json { render json: @media, each_serializer: CharacterImageSerializer }
      format.html do
        set_meta_tags(
            title: 'Your Favorites',
            description: 'Everything you\'ve ever loved in one place (finally)!'
        )

        render 'application/show'
      end
    end
  end
end
