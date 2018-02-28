class Activity::PostSerializer < ActiveModel::Serializer
  attributes :id,
             :forum,
             :thread,
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

  def thread
    {
        id: object.thread.slug,
        topic: object.thread.topic
    }
  end

  def content_html
    object.content.to_html
  end

  def content_text
    object.content.to_text
  end

  def path
    "/forums/#{object.forum.slug}/#{object.thread.slug}#cid:#{object.guid}"
  end
end
