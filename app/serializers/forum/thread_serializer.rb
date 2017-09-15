class Forum::ThreadSerializer < ActiveModel::Serializer
  attributes :topic,
             :content,
             :content_html,
             :path

  has_one :user, serializer: UserIndexSerializer
  has_one :character, serializer: ImageCharacterSerializer

  def content_html
    object.content.to_html
  end

  def path
    "/forums/#{object.forum.slug}/#{object.slug}"
  end
end
