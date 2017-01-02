class ImageSerializer < ActiveModel::Serializer
  attributes :caption, :url

  def url
    object.image&.url
  end
end
