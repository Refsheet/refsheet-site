class CharacterImageSerializer < ActiveModel::Serializer
  attributes :id, :url, :small, :medium

  def id
    object.guid
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
end
