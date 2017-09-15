class Forum::PostSerializer < ActiveModel::Serializer
  include ActionView::Helpers::DateHelper

  attributes :id,
             :thread_id,
             :created_at_human,
             :content,
             :content_html,
             :path,
             :user

  has_one :character, serializer: ImageCharacterSerializer

  def user
    UserIndexSerializer.new(object.user).as_json
  end

  def id
    object.guid
  end

  def thread_id
    object.thread.slug
  end

  def created_at_human
    time_ago_in_words(object.created_at) + ' ago'
  end

  def content_html
    object.content.to_html
  end

  def path
    "/forums/#{object.forum.slug}/threads/#{object.thread.slug}/posts/#{object.guid}"
  end
end
