class Activity::DiscussionSerializer < ActiveModel::Serializer
  attributes :id,
             :forum,
             :topic,
             :content,
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

  def path
    "/forums/#{object.forum.slug}/#{object.slug}"
  end
end
