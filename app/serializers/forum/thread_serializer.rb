class Forum::ThreadSerializer < ActiveModel::Serializer
  include ActionView::Helpers::DateHelper

  attributes :id,
             :forum_id,
             :topic,
             :created_at_human,
             :content,
             :content_html,
             :path

  has_one :user, serializer: UserIndexSerializer
  has_one :character, serializer: ImageCharacterSerializer
  has_many :posts, serializer: Forum::PostSerializer

  def id
    object.slug
  end

  def forum_id
    object.forum.slug
  end

  def created_at_human
    time_ago_in_words(object.created_at) + ' ago'
  end

  def content_html
    object.content.to_html
  end

  def path
    "/forums/#{object.forum.slug}/#{object.slug}"
  end
end
