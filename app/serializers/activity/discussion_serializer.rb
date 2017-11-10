class Activity::DiscussionSerializer < ActiveModel::Serializer
  attributes :id,
             :forum,
             :topic,
             :content,
             :content_text,
             :content_html,
             :path

  def forum
    {
        id: object.forum.slug,
        name: object.forum.name
    }
  end

  def content_html
    object.content.to_html
  end

  def content_text
    object.content.to_text
  end

  def path
    "/forums/#{object.forum.slug}/#{object.slug}"
  end
end
