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
#  hidden            :boolean          default("false")
#  secret            :boolean
#  row_order         :integer
#  deleted_at        :datetime
#  custom_attributes :text
#

class Character < ApplicationRecord
  include HasGuid
  include Sluggable
  include RankedModel

  belongs_to :user
  belongs_to :color_scheme, autosave: true
  belongs_to :featured_image, class_name: "Image"
  belongs_to :profile_image, class_name: "Image"
  has_many :swatches, dependent: :destroy
  has_many :images, dependent: :destroy
  has_many :transfers
  has_and_belongs_to_many :character_groups,
                          after_add: :update_counter_cache,
                          after_remove: :update_counter_cache

  # Marketplace Associations
  has_many :marketplace_listings, class_name: "Marketplace::Items::CharacterListing"
  has_one :marketplace_listing, -> { for_sale }, class_name: "Marketplace::Items::CharacterListing"

  # Requires this to eager load the news feed:
  has_many :activities, as: :activity, dependent: :destroy

  # counter_culture :user

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
  before_create :initialize_custom_attributes
  after_create :log_activity

  before_destroy :decrement_counter_cache

  has_markdown_field :profile
  has_markdown_field :likes
  has_markdown_field :dislikes
  has_markdown_field :special_notes

  has_guid :shortcode, type: :token
  slugify :name, scope: :user_id
  scoped_search on: [:name, :species, :profile, :likes, :dislikes]
  ranks :row_order, with_same: :user_id
  acts_as_paranoid

  serialize :custom_attributes

  def custom_attributes
    a = super
    if a.nil?
      return []
    end
    if a.is_a? String
      Raven.capture { a = YAML.load(a) }
    end
    unless a.is_a? Array
      e = RuntimeError.new("Cannot deserialize custom_attributes: " + a.inspect)
      Raven.capture_exception e unless a.nil?
      return []
    end
    a
  end

  scope :default_order, -> do
    order(<<-SQL)
      CASE
        WHEN characters.profile_image_id IS NULL THEN '1'
        WHEN characters.profile_image_id IS NOT NULL THEN '0'
      END ASC, characters.created_at DESC
    SQL
  end

  scope :sfw, -> { where(nsfw: [nil, false]) }
  scope :visible, -> { where(hidden: false) }
  scope :hidden, -> { where hidden: true }

  scope :visible_to, -> (user) {
    if user
      where <<-SQL.squish, user.id, false
        characters.user_id = ? OR characters.hidden = ?
      SQL
    else
      visible
    end
  }

  scope :for_sale, -> { joins(:marketplace_listings).merge(Item.for_sale) }

  before_validation do
    self.shortcode = self.shortcode&.downcase
  end

  after_update do
    #RefsheetSchema.subscriptions.trigger "characterChanged", { id: self.id }, self
  end


  def username
    self.user.username
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


  #== Marketplace

  def pending_transfer
    self.transfers.pending.last
  end

  def pending_transfer?
    self.transfers.pending.any?
  end

  def for_sale?
    Marketplace::Items::CharacterListing.for_sale.exists? character: self
  end

  def initiate_transfer!(recipient, sale=nil)
    initiate_transfer recipient, sale
  end


  #== API Helpers

  def path
    "/#{self.user.username}/#{self.slug}"
  end

  private

  #== Todo: Migrate this to the CharacterTransferService
  #
  def initiate_transfer(target=self.transfer_to_user, sale_item=nil)
    transfer = Transfer.new character: self, item: sale_item

    Rails.logger.tagged 'Character#initiate_transfer' do
      transfer_to_user = target.downcase
      Rails.logger.info 'Trasnferring to: ' + transfer_to_user.inspect

      if transfer_to_user =~ /@/
        # If this was a sale, sell to unconfirmed users to not lose the sale.
        user_scope = User.all
        user_scope = user_scope.confirmed unless sale_item
        destination = user_scope.find_by 'LOWER(users.email) = ?', transfer_to_user

        if destination
          transfer.destination = destination
          Rails.logger.info 'Sending to: ' + destination.inspect
        else
          transfer.invitation = Invitation.find_or_initialize_by email: transfer_to_user
          Rails.logger.info 'Sending invite: ' + transfer.invitation.inspect
        end

      else
        destination = User.lookup transfer_to_user

        if destination
          transfer.destination = destination
          Rails.logger.info 'Sending to: ' + destination.inspect
        else
          self.errors.add :transfer_to_user, 'must be a valid username or email address'
          Rails.logger.error 'Sending failed: ' + transfer_to_user
          return false
        end
      end

      if transfer.destination == self.user
        self.errors.add :transfer_to_user, 'you can not transfer to yourself'
        Rails.logger.error 'Sending to self, failure!'
        return false
      end

      self.transfers << transfer
    end

    transfer
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

  def update_counter_cache(group)
    counters = {
        characters_count: group.characters.count,
        visible_characters_count: group.characters.visible.count,
        hidden_characters_count: group.characters.hidden.count
    }

    group.update_attributes counters
  end

  def decrement_counter_cache
    self.character_groups.find_each do |g|
      counters = {
          characters_count: g.characters.where.not(id: self.id).count,
          visible_characters_count: g.characters.visible.where.not(id: self.id).count,
          hidden_characters_count: g.characters.hidden.where.not(id: self.id).count
      }

      g.update_attributes counters
    end
  end

  def log_activity
    Activity.create activity: self,
                    user_id: self.user_id,
                    created_at: self.created_at,
                    activity_method: 'create'
  end

  def initialize_custom_attributes
    self.custom_attributes = [
        { id: 'gender', name: 'Gender', value: nil },
        { id: 'height', name: 'Height / Weight', value: nil },
        { id: 'body-type', name: 'Body Type', value: nil }
    ] if !self.custom_attributes || self.custom_attributes.count == 0
  end
end
