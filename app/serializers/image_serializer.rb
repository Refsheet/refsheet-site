class ImageSerializer < ActiveModel::Serializer
  include RichTextHelper
  include Rails.application.routes.url_helpers

  attributes :id,
             :caption,
             :url,
             :path,
             :post_date,
             :caption_html,
             :small,
             :small_square,
             :medium,
             :medium_square,
             :large,
             :large_square,
             :user_id,
             :gravity,
             :source_url,
             :source_url_display

  has_one :character, serializer: ImageCharacterSerializer

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
    object.caption
  end
end
