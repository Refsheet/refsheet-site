# == Schema Information
#
# Table name: characters
#
#  id                :integer          not null, primary key
#  user_id           :integer
#  name              :string
#  slug              :string
#  shortcode         :string
#  profile           :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  gender            :string
#  species           :string
#  height            :string
#  weight            :string
#  body_type         :string
#  personality       :string
#  special_notes     :text
#  featured_image_id :integer
#  profile_image_id  :integer
#  likes             :text
#  dislikes          :text
#  color_scheme_id   :integer
#

class Character < ApplicationRecord
  include HasGuid
  include Sluggable

  belongs_to :user
  belongs_to :color_scheme, autosave: true
  belongs_to :featured_image, class_name: Image
  belongs_to :profile_image, class_name: Image
  has_many :swatches
  has_many :images

  has_guid :shortcode, type: :token
  slugify :name, scope: :user
  scoped_search on: [:name, :species, :profile, :likes, :dislikes]

  accepts_nested_attributes_for :color_scheme

  validates_presence_of :user
  validates :name,
            presence: true,
            format: { with: /[a-z]/i, message: 'must have at least one letter' }

  scope :default_order, -> do
    order(<<-SQL)
      CASE
        WHEN characters.profile_image_id IS NULL THEN '1'
        WHEN characters.profile_image_id IS NOT NULL THEN '0'
      END, lower(characters.name) ASC
    SQL
  end

  def description
    ''
  end

  def nickname
    ''
  end

  def profile_image
    super || Image.new
  end

  def self.lookup(slug)
    find_by('LOWER(characters.slug) = ?', slug.downcase)
  end

  def self.lookup!(slug)
    find_by!('LOWER(characters.slug) = ?', slug.downcase)
  end
end
