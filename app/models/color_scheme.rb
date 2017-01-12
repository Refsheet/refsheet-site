class ColorScheme < ApplicationRecord
  include HasGuid

  belongs_to :user
  has_many :characters

  has_guid
  serialize :color_data
end
