class CharacterGroupSerializer < ActiveModel::Serializer
  attributes :name,
             :slug,
             :hidden,
             :characters_count,
             :visible_characters_count,
             :hidden_characters_count,
             :link,
             :path

  def link
    "/#{object.user.username}##{object.slug}"
  end

  def path
    "/character_groups/#{object.slug}"
  end
end
