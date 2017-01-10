class ImageSerializer < ActiveModel::Serializer
  include RichTextHelper
  include Rails.application.routes.url_helpers

  attributes :id, :caption, :url, :path, :post_date, :caption_html

  has_one :character, serializer: ImageCharacterSerializer

  def id
    object.guid
  end

  def url
    object.image&.url
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
