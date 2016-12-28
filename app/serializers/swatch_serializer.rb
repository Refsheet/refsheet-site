class SwatchSerializer < ActiveModel::Serializer
  attributes :id, :name, :color, :notes

  def id
    object.guid
  end
end
