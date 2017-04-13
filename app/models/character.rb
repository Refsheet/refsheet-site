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
#  nsfw              :boolean
#  hidden            :boolean
#  secret            :boolean
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
  has_many :transfers

  has_guid :shortcode, type: :token
  slugify :name, scope: :user_id
  scoped_search on: [:name, :species, :profile, :likes, :dislikes]

  accepts_nested_attributes_for :color_scheme

  attr_accessor :transfer_to_user

  validates_presence_of :user
  validates_associated :transfers

  validates :name,
            presence: true,
            format: { with: /[a-z]/i, message: 'must have at least one letter' }

  validate :validate_profile_image
  validate :validate_featured_image

  before_validation :initiate_transfer, if: -> (c) { c.transfer_to_user.present? }

  scope :default_order, -> do
    order(<<-SQL)
      CASE
        WHEN characters.profile_image_id IS NULL THEN '1'
        WHEN characters.profile_image_id IS NOT NULL THEN '0'
      END, lower(characters.name) ASC
    SQL
  end

  scope :sfw, -> { where(nsfw: [nil, false]) }
  scope :visible, -> { where(hidden: [nil, false]) }

  before_validation do
    self.shortcode = self.shortcode&.downcase
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

  def managed_by?(user)
    self.user == user
  end

  def self.lookup(slug)
    find_by('LOWER(characters.slug) = ?', slug.downcase)
  end

  def self.lookup!(slug)
    find_by!('LOWER(characters.slug) = ?', slug.downcase)
  end

  def self.find_by_shortcode!(shortcode)
    find_by!('LOWER(characters.shortcode) = ?', shortcode.downcase)
  end

  def pending_transfer
    self.transfers.pending.last
  end

  def pending_transfer?
    self.transfers.pending.any?
  end

  def path
    "/#{self.user.username}/#{self.slug}"
  end

  private

  def initiate_transfer
    transfer = Transfer.new character: self
    transfer_to_user = self.transfer_to_user.downcase

    if transfer_to_user =~ /@/
      destination = User.find_by 'LOWER(users.email) = ?', transfer_to_user

      if destination
        transfer.destination = destination
      else
        transfer.invitation = Invitation.find_or_initialize_by email: transfer_to_user
      end
    else
      destination = User.lookup transfer_to_user

      if destination
        transfer.destination = destination
      else
        self.errors.add :transfer_to_user, 'must be a valid username or email address, was: ' + transfer_to_user.inspect
        return false
      end
    end

    self.transfers << transfer
  end

  def validate_profile_image
    unless self.profile_image.nil?
      self.errors.add :profile_image, 'cannot be NSFW' if self.profile_image.nsfw?
      false
    end
  end

  def validate_featured_image
    unless self.featured_image.nil?
      self.errors.add :featured_image, 'cannot be NSFW' if self.featured_image.nsfw?
      false
    end
  end
end
