class CharacterImageSerializer < ActiveModel::Serializer
  attributes :id, :url

  def id
    object.guid
  end

  def url
    object.image&.url
  end
end
