# == Schema Information
#
# Table name: swatches
#
#  id           :integer          not null, primary key
#  character_id :integer
#  name         :string
#  color        :string
#  notes        :text
#  row_order    :integer
#  guid         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_swatches_on_character_id  (character_id)
#  index_swatches_on_guid          (guid)
#  index_swatches_on_row_order     (row_order)
#

class SwatchSerializer < ActiveModel::Serializer
  attributes :id, :name, :color, :notes

  def id
    object.guid
  end
end
