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

  validates_presence_of :topic
  validates_presence_of :user
  validates_presence_of :forum
  validates_presence_of :slug
  validates_presence_of :content

  slugify :topic
  has_guid :shortcode, type: :shortcode
end
