class CharacterGroupSerializer < ActiveModel::Serializer
  attributes :name,
             :slug,
             :hidden,
             :link,
             :path

  def link
    "/#{object.user.username}##{object.slug}"
  end

  def path
    "/character_groups/#{object.slug}"
  end
end
