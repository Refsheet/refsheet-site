# == Schema Information
#
# Table name: forums
#
#  id          :integer          not null, primary key
#  name        :string
#  description :text
#  slug        :string
#  locked      :boolean
#  nsfw        :boolean
#  no_rp       :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Forum < ApplicationRecord
  include Sluggable

  has_many :threads, class_name: Forum::Discussion
  has_many :posts, class_name: Forum::Post, through: :threads

  validates_presence_of :name
  validates_presence_of :slug

  slugify :name


  #== Eventually move to a column / cache

  def group_name
    'General'
  end

  def thread_count
    threads.count
  end

  #== Lookups

  def self.lookup(slug)
    self.find_by 'LOWER(forums.slug) = ?', slug&.to_s&.downcase
  end

  def self.lookup!(*args)
    self.lookup(*args) or raise ActiveRecord::RecordNotFound.new "Couldn't find Forum with slug #{args[0]}.", Forum
  end
end
