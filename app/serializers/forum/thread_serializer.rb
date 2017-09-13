class Forum::ThreadSerializer
  attributes :topic,
             :content,
             :content_html

  has_one :user, serializer: UserIndexSerializer
  has_one :character, serializer: ImageCharacterSerializer

  def content_html
    content.to_html
  end
end
