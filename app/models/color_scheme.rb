# == Schema Information
#
# Table name: color_schemes
#
#  id         :integer          not null, primary key
#  name       :string
#  user_id    :integer
#  color_data :text
#  guid       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ColorScheme < ApplicationRecord
  include HasGuid

  COLOR_MATCH = /\A((rgb|hsl)a?\((\s*\d,){3,4}\s*\)|#?([a-f0-9]{3}|[a-f0-9]{6}|[a-f0-9]{8}))\z/i

  belongs_to :user
  has_many :characters

  validate :validate_color_data

  has_guid
  serialize :color_data

  private

  def validate_color_data
    if color_data.is_a? Hash
      color_data.collect do |k, v|
        self.errors.add k, 'Must be RGB, HSL or Hex code.' unless v.match COLOR_MATCH
      end
    else
      self.errors.add :color_data, 'Malformed :('
    end
  end
end
