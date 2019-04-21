# == Schema Information
#
# Table name: media_favorites
#
#  id         :integer          not null, primary key
#  media_id   :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_media_favorites_on_media_id  (media_id)
#  index_media_favorites_on_user_id   (user_id)
#

class Media::FavoriteSerializer < ActiveModel::Serializer
  attributes :id,
             :media_id,
             :user_id,
             :user_avatar_url,
             :created_at

  def id
    object.guid
  end

  def media_id
    object.media.guid
  end

  def user_id
    object.user.username
  end

  def user_avatar_url
    object.user.avatar_url
  end
end
