class Media::FavoriteSerializer < ActiveModel::Serializer
  attributes :media_id,
             :user_id,
             :created_at

  def media_id
    object.media.guid
  end

  def user_id
    object.user.username
  end
end
