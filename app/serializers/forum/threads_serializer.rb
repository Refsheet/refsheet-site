class Forum::ThreadsSerializer < ActiveModel::Serializer
  attributes :id,
             :topic,
             :summary,
             :username,
             :poster_name
             :avatar_url

  def id
    object.slug
  end

  def username
    object.user.username
  end

  def poster_name
    object.user.name
  end

  def avatar_url
    object.user.avatar_url
  end

  def summary
    object.content.to_text&.truncate(240)
  end
end
