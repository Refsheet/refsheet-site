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
#  admin_post     :boolean          default(FALSE)
#  moderator_post :boolean          default(FALSE)
#  deleted_at     :datetime
#  edited         :boolean          default(FALSE)
#
# Indexes
#
#  index_forum_posts_on_character_id    (character_id)
#  index_forum_posts_on_deleted_at      (deleted_at)
#  index_forum_posts_on_guid            (guid)
#  index_forum_posts_on_parent_post_id  (parent_post_id)
#  index_forum_posts_on_thread_id       (thread_id)
#  index_forum_posts_on_user_id         (user_id)
#

class Forum::Post < ApplicationRecord
  include HasGuid
  include Rails.application.routes.url_helpers

  belongs_to :user
  belongs_to :character
  belongs_to :discussion, class_name: "Forum::Discussion", foreign_key: :thread_id, inverse_of: :posts
  belongs_to :parent_post, class_name: "Forum::Post", foreign_key: :parent_post_id
  has_many :replies, class_name: "Forum::Post", foreign_key: :parent_post_id
  has_many :karmas, class_name: "Forum::Karma", foreign_key: :karmic_id, as: :karmic
  has_one :forum, through: :discussion, class_name: "Forum"

  validates_presence_of :content
  validates_presence_of :user
  validates_presence_of :discussion

  before_validation :assign_admin_level
  before_update :set_edited

  after_create :notify_user
  after_create :notify_tagged

  has_guid
  has_markdown_field :content
  acts_as_paranoid
  counter_culture [:discussion, :forum]
  counter_culture :discussion

  has_paper_trail only: [:content, :thread_id, :character_id]

  def thread
    ActiveSupport::Deprecation.warn("Forum::Post#thread is now Forum::Post#discussion, use that.")
    discussion
  end

  # If called without a user, it will assume you are using the ::with_unread_counts scope
  # on the parent discussion association. If you are not, pass a user. Beware N+1
  #
  def read_by?(user=nil)
    with self.thread.last_read_at(user), true do |last_read_at|
      created_at <= last_read_at
    end
  end

  def notify_user
    Notifications::ForumReply.notify! thread.user, user, self
  end

  private

  def notify_tagged
    tags = content.extract_tags only_users: true
    usernames = tags.collect { |t| t[:username].downcase }

    User.lookup(usernames).each do |tagged_user|
      next if tagged_user.id == thread.user.id
      Notifications::ForumTag.notify! tagged_user, user, self
    end
  end

  def assign_admin_level
    self.admin_post = user&.admin?
    self.moderator_post = user&.moderator?
  end

  def set_edited
    if content_changed?
      self.edited ||= true
    end
  end
end
