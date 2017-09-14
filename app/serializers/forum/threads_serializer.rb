class Forum::ThreadsSerializer < ActiveModel::Serializer
  attributes :topic,
             :summary,
             :username,
             :poster_name
             :avatar_url

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
    content.to_text&.truncate(240)
  end
end
