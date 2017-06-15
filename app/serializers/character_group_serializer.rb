class CharacterGroupSerializer < ActiveModel::Serializer
  attributes :name,
             :slug,
             :hidden
end
