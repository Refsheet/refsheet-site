class ImageSerializer < ActiveModel::Serializer
  attributes :id, :caption, :url

  has_one :character, serializer: ImageCharacterSerializer

  def id
    object.guid
  end

  def url
    object.image&.url
  end
end
