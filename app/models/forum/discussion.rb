# == Schema Information
#
# Table name: forum_threads
#
#  id           :integer          not null, primary key
#  forum_id     :integer
#  user_id      :integer
#  character_id :integer
#  topic        :string
#  slug         :string
#  shortcode    :string
#  content      :text
#  locked       :boolean
#  karma_total  :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  content_html :string
#
# Indexes
#
#  index_forum_threads_on_character_id  (character_id)
#  index_forum_threads_on_forum_id      (forum_id)
#  index_forum_threads_on_karma_total   (karma_total)
#  index_forum_threads_on_shortcode     (shortcode)
#  index_forum_threads_on_slug          (slug)
#  index_forum_threads_on_user_id       (user_id)
#

class Forum::Discussion < ApplicationRecord
  self.table_name = 'forum_threads'

  include Sluggable
  include HasGuid

  belongs_to :forum
  belongs_to :user
  belongs_to :character
  has_many :posts, -> { order('forum_posts.created_at ASC') }, class_name: "Forum::Post", foreign_key: :thread_id, inverse_of: :thread
  has_many :karmas, class_name: "Forum::Karma", as: :karmic, foreign_key: :karmic_id
  has_many :subscriptions, class_name: "Forum::Subscription", foreign_key: :discussion_id

  # Requires this to eager load the news feed:
  has_many :activities, as: :activity, dependent: :destroy

  validates_presence_of :topic
  validates_presence_of :user
  validates_presence_of :forum
  validates_presence_of :slug
  validates_presence_of :content

  after_create :log_activity

  slugify :topic, lookups: true
  has_guid :shortcode, type: :shortcode

  scope :with_unread_count, -> (user) {
    joins(sanitize_sql_array [<<-SQL.squish, user&.id]).
        LEFT OUTER JOIN ( 
            SELECT COUNT(*) AS unread_posts_count, forum_posts.thread_id FROM forum_posts
            INNER JOIN forum_threads ON forum_posts.thread_id = forum_threads.id
            INNER JOIN forum_subscriptions ON forum_subscriptions.discussion_id = forum_threads.id
            WHERE forum_posts.created_at > forum_subscriptions.last_read_at
              AND forum_subscriptions.user_id = ?
            GROUP BY forum_posts.thread_id
        ) urc ON urc.thread_id = forum_threads.id
    SQL

    left_outer_joins(:subscriptions).
    where(subscriptions_forum_threads: { user_id: [user&.id, nil] }).
    select('forum_threads.*, subscriptions_forum_threads.last_read_at AS last_read_cache, urc.unread_posts_count AS unread_posts_count')
  }

  scope :with_last_post_at, -> {
    joins(<<-SQL.squish).
        LEFT OUTER JOIN (
            SELECT MAX(forum_posts.created_at) AS last_post_at, forum_posts.thread_id FROM forum_posts
            GROUP BY forum_posts.thread_id
        ) lpa ON lpa.thread_id = forum_threads.id
    SQL

    select('forum_threads.*, lpa.last_post_at AS last_post_at')
  }

  def content
    super.to_md
  end

  def last_read_at(user)
    if self.attributes.include? 'last_read_cache'
      self.last_read_cache
    else
      self.subscriptions.find_by(user: user)&.last_read_at
    end
  end

  def unread_posts_count
    if self.attributes.include? 'unread_posts_count'
      self.attributes['unread_posts_count']
    else
      nil
    end
  end

  def preview
    content && content.truncate(120)
  end

  private

  def log_activity
    Activity.create activity: self,
                    user_id: self.user_id,
                    character_id: self.character_id,
                    created_at: self.created_at,
                    activity_method: 'create'
  end
end
