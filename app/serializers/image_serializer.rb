class ImageSerializer < ActiveModel::Serializer
  attributes :id, :caption, :url

  has_one :character, serializer: CharacterSerializer

  def id
    object.guid
  end

  def url
    object.image&.url
  end
end
