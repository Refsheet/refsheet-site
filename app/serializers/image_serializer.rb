class ImageSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :caption, :url, :path

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
end
