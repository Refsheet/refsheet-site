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
