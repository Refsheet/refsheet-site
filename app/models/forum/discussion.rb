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
#

class Forum::Discussion < ApplicationRecord
  self.table_name = 'forum_threads'

  include Sluggable
  include HasGuid

  belongs_to :forum
  belongs_to :user
  belongs_to :character
  has_many :posts, class_name: Forum::Post, foreign_key: :thread_id
  has_many :karmas, class_name: Forum::Karma, as: :karmic, foreign_key: :karmic_id

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

  def content
    super.to_md
  end

  private

  def log_activity
    Activity.create activity: self, user_id: self.user_id, character_id: self.character_id, created_at: self.created_at, activity_method: 'create'
  end
end
