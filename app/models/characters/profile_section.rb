# == Schema Information
#
# Table name: characters_profile_sections
#
#  id            :integer          not null, primary key
#  guid          :string
#  character_id  :integer
#  row_order     :integer
#  title         :string
#  column_widths :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_characters_profile_sections_on_character_id  (character_id)
#  index_characters_profile_sections_on_guid          (guid)
#  index_characters_profile_sections_on_row_order     (row_order)
#

class Characters::ProfileSection < ApplicationRecord
  include HasGuid

  belongs_to :character
  has_many :widgets, class_name: 'Characters::ProfileWidget'

  validates_format_of :column_widths, with: /\A\d+(,\d+)*\z/, message: 'numbers and commas only'
  validate :check_column_sums

  has_guid

  def columns
    self.column_widths&.split(',').collect(&:to_i)
  end

  def columns=(cols)
    self.column_widths = cols.join(',')
  end

  private

  def check_column_sums
    if columns&.sum != 12
      errors.add(:column_widths, "must sum to 12")
    end
  end
end
