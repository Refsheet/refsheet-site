# == Schema Information
#
# Table name: forums
#
#  id                :integer          not null, primary key
#  name              :string
#  description       :text
#  slug              :string
#  locked            :boolean
#  nsfw              :boolean
#  no_rp             :boolean
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  system_owned      :boolean          default(FALSE)
#  rules             :text
#  prepost_message   :text
#  owner_id          :integer
#  fandom_id         :integer
#  open              :boolean          default(FALSE)
#  summary           :text
#  discussions_count :integer          default(0), not null
#  members_count     :integer          default(0), not null
#  posts_count       :integer          default(0), not null
#
# Indexes
#
#  index_forums_on_fandom_id     (fandom_id)
#  index_forums_on_lower_slug    (lower((slug)::text) varchar_pattern_ops)
#  index_forums_on_owner_id      (owner_id)
#  index_forums_on_system_owned  (system_owned)
#

class Forum < ApplicationRecord
  include Sluggable

  belongs_to :owner, -> { with_deleted }, class_name: 'User', optional: true
  has_many :discussions, class_name: "Forum::Discussion"
  has_many :posts, class_name: "Forum::Post", through: :discussions

  def threads
    ActiveSupport::Deprecation.warn("Forum#threads is finally Forum#discussions, please use that.")
    discussions
  end

  validates_presence_of :name
  validates_presence_of :slug

  slugify :name, lookups: true

  # @deprecated Forums never ended up being grouped.
  def group_name
    'General'
  end

  def thread_count
    ActiveSupport::Deprecation.warn("Forum#thread_count is not right, use Forum#discussions_count")
    discussions_count
  end

  # Member Management

  def has_member?(_user)
    system_owned?
  end

  def member_count
    system_owned? ? User.count : 0
  end
end
