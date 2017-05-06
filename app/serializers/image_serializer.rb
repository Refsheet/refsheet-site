class ImageSerializer < ActiveModel::Serializer
  include RichTextHelper
  include SessionHelper
  include Rails.application.routes.url_helpers

  attributes :id,
             :title,
             :caption,
             :url,
             :path,
             :post_date,
             :caption_html,
             :background_color,
             :nsfw,
             :hidden,
             :small,
             :small_square,
             :medium,
             :medium_square,
             :large,
             :large_square,
             :user_id,
             :gravity,
             :source_url,
             :source_url_display,
             :is_favorite,
             :favorite_count,
             :comment_count

  has_one :character, serializer: ImageCharacterSerializer
  has_many :favorites, serializer: Media::FavoriteSerializer

  def id
    object.guid
  end

  def user_id
    object.character.user.username
  end

  def url
    object.image&.url(:large)
  end

  def small
    object.image&.url(:small)
  end

  def small_square
    object.image&.url(:small_square)
  end

  def medium
    object.image&.url(:medium)
  end

  def medium_square
    object.image&.url(:medium_square)
  end

  def large
    object.image&.url(:large)
  end

  def large_square
    object.image&.url(:large_square)
  end

  def path
    image_path object
  end

  def post_date
    object.created_at.strftime('%B %-d, %Y')
  end

  def caption_html
    linkify object.caption, markdown: false
  end

  def is_favorite
    object.favorites.any? { |f| f.user == current_user } if signed_in?
  end

  def favorite_count
    object.favorites.length
  end

  def comment_count
    object.comments.count
  end

  def session
    scope.session
  end
end
