# == Schema Information
#
# Table name: forums
#
#  id              :integer          not null, primary key
#  name            :string
#  description     :text
#  slug            :string
#  locked          :boolean
#  nsfw            :boolean
#  no_rp           :boolean
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  system_owned    :boolean          default(FALSE)
#  rules           :text
#  prepost_message :text
#  owner_id        :integer
#  fandom_id       :integer
#  open            :boolean          default(FALSE)
#
# Indexes
#
#  index_forums_on_fandom_id     (fandom_id)
#  index_forums_on_owner_id      (owner_id)
#  index_forums_on_slug          (slug)
#  index_forums_on_system_owned  (system_owned)
#

class Forum < ApplicationRecord
  include Sluggable

  belongs_to :owner, -> { with_deleted }, class_name: 'User', optional: true
  has_many :threads, class_name: "Forum::Discussion"
  has_many :posts, class_name: "Forum::Post", through: :threads

  validates_presence_of :name
  validates_presence_of :slug

  slugify :name, lookups: true

  # @deprecated Forums never ended up being grouped.
  def group_name
    'General'
  end

  def thread_count
    threads.count
  end

  def discussion_count
    thread_count
  end

  # Member Management

  def has_member?(_user)
    system_owned?
  end

  def member_count
    system_owned? ? User.count : 0
  end
end
