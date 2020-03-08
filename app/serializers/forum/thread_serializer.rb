# @deprecated Use Forum::DiscussionSerializer
class Forum::ThreadSerializer < ActiveModel::Serializer
  include ActionView::Helpers::DateHelper

  attributes :id,
             :guid,
             :forum_id,
             :topic,
             :created_at_human,
             :content,
             :content_html,
             :unread_posts_count,
             :path,
             :posts

  has_one :user, serializer: UserIndexSerializer
  has_one :character, serializer: ImageCharacterSerializer

  # Because for some reason it was reloading the parent otherwise, and that's not gucci.
  #
  def posts
    object.posts.collect do |post|
      post.discussion = object
      Forum::PostSerializer.new post, scope: scope, root: false
    end
  end

  def id
    object.slug
  end

  def guid
    object.id
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
