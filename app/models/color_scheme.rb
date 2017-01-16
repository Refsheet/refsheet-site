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

  belongs_to :user
  has_many :characters

  has_guid
  serialize :color_data
end
