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

class Swatch < ApplicationRecord
  include HasGuid
  include RankedModel

  belongs_to :character, inverse_of: :swatches

  has_guid
  ranks :row_order, with_same: :character_id

  validates_presence_of :name
  validates_presence_of :color
  validates_presence_of :character

  validates_format_of :color, with: /\A#?[a-f0-9]{6}\z/i, message: 'can only use hexadecimal color codes'

  before_validation do
    color.prepend '#' unless color.nil? || color[0] == '#'
  end
end
