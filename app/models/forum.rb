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

  def group_name
    'General'
  end

  #== Lookups

  def self.lookup(slug)
    self.find_by slug: slug
  end

  def self.lookup!(*args)
    lookup(*args) or raise ActiveRecord::RecordNotFound.new "Couldn't find Forum with slug #{args[0]}.", Forum
  end
end
