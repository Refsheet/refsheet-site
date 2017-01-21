class ImageSerializer < ActiveModel::Serializer
  include RichTextHelper
  include Rails.application.routes.url_helpers

  attributes :id, :caption, :url, :path, :post_date, :caption_html, :small, :medium, :user_id, :gravity

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

  def medium
    object.image&.url(:medium)
  end

  def path
    image_path object
  end

  def post_date
    object.created_at.strftime('%B %-d, %Y')
  end

  def caption_html
    linkify object.caption
  end
end
