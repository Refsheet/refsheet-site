# == Schema Information
#
# Table name: characters_profile_widgets
#
#  id                 :integer          not null, primary key
#  guid               :string
#  character_id       :integer
#  profile_section_id :integer
#  column             :integer
#  row_order          :integer
#  widget_type        :string
#  title              :string
#  data               :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_characters_profile_widgets_on_character_id        (character_id)
#  index_characters_profile_widgets_on_guid                (guid)
#  index_characters_profile_widgets_on_profile_section_id  (profile_section_id)
#  index_characters_profile_widgets_on_row_order           (row_order)
#

class Characters::ProfileWidget < ApplicationRecord
  include HasGuid

  belongs_to :character
  belongs_to :profile_section, class_name: 'Characters::ProfileSection'

  validates_numericality_of :column,
                            only_integer: true,
                            less_than: 12,
                            greater_than_or_equal_to: 0

  has_guid

  serialize :data
end
