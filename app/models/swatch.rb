class Swatch < ApplicationRecord
  include HasGuid

  belongs_to :character, inverse_of: :swatches

  has_guid

  validates_presence_of :name
  validates_presence_of :color
  validates_presence_of :character

  validates_format_of :color, with: /\A#?[a-f0-9]{6}\z/i, message: 'can only use hexadecimal color codes'

  before_validation do
    color.prepend '#' unless color[0] == '#'
  end
end
