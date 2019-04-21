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

class ColorSchemeSerializer < ActiveModel::Serializer
  attributes :name, :user_id, :color_data

  def user_id
    nil # object.user&.username
  end
end
