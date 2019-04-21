# == Schema Information
#
# Table name: forum_posts
#
#  id             :integer          not null, primary key
#  thread_id      :integer
#  user_id        :integer
#  character_id   :integer
#  parent_post_id :integer
#  guid           :string
#  content        :text
#  karma_total    :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  content_html   :string
#
# Indexes
#
#  index_forum_posts_on_character_id    (character_id)
#  index_forum_posts_on_guid            (guid)
#  index_forum_posts_on_parent_post_id  (parent_post_id)
#  index_forum_posts_on_thread_id       (thread_id)
#  index_forum_posts_on_user_id         (user_id)
#

class Forum::PostSerializer < ActiveModel::Serializer
  include ActionView::Helpers::DateHelper

  attributes :id,
             :thread_id,
             :created_at_human,
             :content,
             :content_html,
             :path,
             :unread,
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

  def unread
    !object.read_by?
  end

  def path
    "/forums/#{object.forum.slug}/threads/#{object.thread.slug}/posts/#{object.guid}"
  end
end
