class CharacterImageSerializer < ActiveModel::Serializer
  attributes :id,
             :url,
             :small,
             :small_square,
             :medium,
             :medium_square,
             :large,
             :large_square,
             :gravity

  def id
    object.guid
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
end
