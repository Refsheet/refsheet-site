class ColorSchemeSerializer < ActiveModel::Serializer
  attributes :name, :user_id, :color_data

  def user_id
    object.user&.username
  end
end
