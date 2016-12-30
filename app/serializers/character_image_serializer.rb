class CharacterImageSerializer < ActiveModel::Serializer
  attributes :url

  def url
    object.image&.url
  end
end
