class Forum::ThreadsSerializer < ActiveModel::Serializer
  attributes :id,
             :topic,
             :summary,
             :username,
             :user_name,
             :avatar_url,
             :posts_count,
             :unread_posts_count,
             :last_post_at,
             :path

  def id
    object.slug
  end

  def username
    object.user.username
  end

  def last_post_at
    object.last_post_at&.to_i || object.created_at.to_i
  end

  def user_name
    object.user.name
  end

  def posts_count
    object.posts.count
  end

  def avatar_url
    object.user.avatar_url
  end

  def summary
    object.content.to_text&.truncate(240)
  end

  def path
    "/forums/#{object.forum.slug}/#{object.slug}"
  end
end
