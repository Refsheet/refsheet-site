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

FactoryBot.define do
  factory :swatch do
    character
    name { "Swatch Name" }
    color { "#00FF00" }
    notes { nil }
  end
end
