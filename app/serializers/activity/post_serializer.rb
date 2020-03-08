class Activity::PostSerializer < ActiveModel::Serializer
  attributes :id,
             :forum,
             :thread, # Deprecated
             :discussion,
             :content,
             :content_text,
             :content_html,
             :path

  def id
    object.guid
  end

  def forum
    {
        id: object.forum.slug,
        name: object.forum.name
    }
  end

  def discussion
    {
        id: object.discussion.slug,
        topic: object.discussion.topic
    }
  end

  def thread
    discussion
  end

  def content_html
    object.content.to_html
  end

  def content_text
    object.content.to_text
  end

  def path
    "/forums/#{object.forum.slug}/#{object.discussion.slug}#cid:#{object.guid}"
  end
end
