class CharacterGroupSerializer < ActiveModel::Serializer
  attributes :name,
             :slug,
             :hidden,
             :characters_count,
             :link,
             :path

  def characters_count
    object.characters.visible.count
  end

  def link
    "/#{object.user.username}##{object.slug}"
  end

  def path
    "/character_groups/#{object.slug}"
  end
end
