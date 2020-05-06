# == Schema Information
#
# Table name: character_groups
#
#  id                       :integer          not null, primary key
#  user_id                  :integer
#  name                     :string
#  slug                     :string
#  row_order                :integer
#  hidden                   :boolean
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  characters_count         :integer          default(0), not null
#  visible_characters_count :integer          default(0), not null
#  hidden_characters_count  :integer          default(0), not null
#
# Indexes
#
#  index_character_groups_on_hidden     (hidden)
#  index_character_groups_on_row_order  (row_order)
#  index_character_groups_on_slug       (slug)
#  index_character_groups_on_user_id    (user_id)
#

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
