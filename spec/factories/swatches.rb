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

FactoryBot.define do
  factory :swatch do
    character
    name { "Swatch Name" }
    color { "#00FF00" }
    notes { nil }
  end
end
