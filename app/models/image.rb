# == Schema Information
#
# Table name: images
#
#  id                      :integer          not null, primary key
#  character_id            :integer
#  artist_id               :integer
#  caption                 :string
#  source_url              :string
#  image_file_name         :string
#  image_content_type      :string
#  image_file_size         :bigint
#  image_updated_at        :datetime
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  row_order               :integer
#  guid                    :string
#  gravity                 :string
#  nsfw                    :boolean
#  hidden                  :boolean          default(FALSE)
#  gallery_id              :integer
#  deleted_at              :datetime
#  title                   :string
#  background_color        :string
#  comments_count          :integer
#  favorites_count         :integer
#  image_meta              :text
#  image_processing        :boolean          default(FALSE)
#  image_direct_upload_url :string
#  watermark               :boolean
#  custom_watermark_id     :integer
#  annotation              :boolean
#  custom_annotation       :string
#  image_phash             :bit(64)
#
# Indexes
#
#  index_images_on_character_id         (character_id)
#  index_images_on_custom_watermark_id  (custom_watermark_id)
#  index_images_on_deleted_at           (deleted_at)
#  index_images_on_gallery_id           (gallery_id)
#  index_images_on_guid                 (guid)
#  index_images_on_hidden               (hidden)
#  index_images_on_image_processing     (image_processing)
#  index_images_on_row_order            (row_order)
#

# Should me larger than 1280px in both dimensions,
# TODO - This will be refactored to be an STI class of Media
class Image < ApplicationRecord # < Media
  include HasGuid
  include RankedModel
  include HasDirectUpload

  IMAGE_GRAVITIES = %w(NorthWest North NorthEast West Center East SouthWest South SouthEast)

  belongs_to :character, inverse_of: :images
  has_one :user, through: :character
  has_many :favorites, foreign_key: :media_id, class_name: "Media::Favorite", dependent: :destroy
  has_many :comments, foreign_key: :media_id, class_name: "Media::Comment", dependent: :destroy
  has_many :tags, foreign_key: :media_id, class_name: "Media::Tag", dependent: :destroy
  has_and_belongs_to_many :hashtags, class_name: "Media::Hashtag", association_foreign_key: :media_hashtag_id

  # Requires this to eager load the news feed:
  has_many :activities, as: :activity, dependent: :destroy

  delegate :aspect_ratio, :width, :height, to: :image

  SIZE = {
      thumbnail: 320,
      small: 427,
      medium: 854,
      large: 1280
  }

  has_attached_file :image,
                    default_url: '/assets/default.png',
                    processors: [:upload_processor],
                    styles: {
                        thumbnail: "#{SIZE[:thumbnail]}x#{SIZE[:thumbnail]}^",
                        small: "#{SIZE[:small]}x#{SIZE[:small]}>",
                        small_square: "#{SIZE[:small]}x#{SIZE[:small]}^",
                        medium: "#{SIZE[:medium]}x#{SIZE[:medium]}>",
                        medium_square: "#{SIZE[:medium]}x#{SIZE[:medium]}^",
                        large: "#{SIZE[:large]}x#{SIZE[:large]}>",
                        large_square: "#{SIZE[:large]}x#{SIZE[:large]}^"
                    },
                    s3_permissions: {
                        original: :private
                    },
                    convert_options: {
                       thumbnail:     -> (i) { "+repage -gravity '#{i.gravity}' -crop '#{SIZE[:thumbnail]}x#{SIZE[:thumbnail]}+0+0'" },
                       small_square:  -> (i) { "+repage -gravity '#{i.gravity}' -crop '#{SIZE[:small]}x#{SIZE[:small]}+0+0'" },
                       medium_square: -> (i) { "+repage -gravity '#{i.gravity}' -crop '#{SIZE[:medium]}x#{SIZE[:medium]}+0+0'" },
                       large_square:  -> (i) { "+repage -gravity '#{i.gravity}' -crop '#{SIZE[:large]}x#{SIZE[:large]}+0+0'" }
                    }


  validates_attachment :image,
                       content_type: { content_type: /image\/*/ },
                       size: { in: 0..25.megabytes }

  validates_attachment_presence :image,
                                unless: -> (i) { i.image_direct_upload_url.present? }

  process_in_background :image,
                        processing_image_url: -> (attachment) {
                          ActionController::Base.helpers.image_path("placeholders/processing_500.png")
                        }

  has_direct_upload :image

  validates_format_of :background_color,
                      with: ColorScheme::COLOR_MATCH,
                      message: 'must be RGB, HSL or Hex code',
                      allow_blank: true,
                      if: -> { background_color_changed? }

  validates_inclusion_of :gravity,
                         in: IMAGE_GRAVITIES,
                         message: 'must be a valid image gravity',
                         allow_blank: true,
                         if: -> { gravity_changed? }

  has_guid
  ranks :row_order, with_same: :character_id
  acts_as_paranoid
  has_markdown_field :caption

  before_validation :adjust_source_url
  after_save :clean_up_character
  after_save :sync_hashtags
  after_save :contemplate_reprocessing
  after_destroy :clean_up_character

  scoped_search on: [:caption, :image_file_name]
  scoped_search relation: :character, on: [:name, :species]

  scope :unflagged, -> { where(nsfw: nil) }
  scope :sfw, -> { where(nsfw: [false, nil]) }
  scope :nsfw, -> { where(nsfw: true) }
  scope :visible, -> { where(hidden: false) }

  scope :processing, -> { where(image_processing: true) }
  scope :processed,  -> { where(image_processing: false) }

  scope :similar_to, -> (image, distance: 7) {
    target_hash = image.image_phash

    if target_hash.nil?
      return all
    end

    with_phash_distance(image).
    where(<<-SQL.squish, image.id, target_hash, distance)
      images.id != ? AND length(regexp_replace((B? # images.image_phash)::text, '[^1]', '', 'g')) < ?
    SQL
  }

  scope :with_phash_distance, -> (image) {
    target_hash = image.image_phash

    if target_hash.nil?
      return all
    end

    select(sanitize_sql_array([<<-SQL.squish, target_hash]))
      images.*, length(regexp_replace((B? # images.image_phash)::text, '[^1]', '', 'g')) AS phash_distance
    SQL
  }

  scope :visible_to, -> (user, include_hidden_characters = false) {
    if user
      joins(:character).
      where(<<-SQL.squish, user.id)
        ( characters.user_id = ? ) OR (
            #{ include_hidden_characters ? "" : "characters.hidden = 'f' AND " } images.hidden = 'f'
        )
      SQL
    elsif include_hidden_characters
      visible
    else
      joins(:character).
      where(characters: { hidden: false }).
      visible
    end
  }

  def processed?
    !self.image_processing?
  end

  def title
    super || "Image of #{self.character&.name || 'Anonymous'}"
  end

  def background_color
    color = if super
              super
            elsif self.character&.color_scheme
              c = self.character.color_scheme['imageBackground']
              c&.match(ColorScheme::COLOR_MATCH) ? c : nil
            end

    color || '#000000'
  end

  def source_url_display
    return nil unless self.source_url.present?
    output = self.source_url.dup
    output.gsub! /^\w+:\/\//, ''
    output.gsub! /\/.*\//, '/.../'
    output.gsub! /\?[^?]+$/, ''
    output.gsub! /#[^#]+$/, ''
    output
  end

  def download_link
    Rails.application.routes.url_helpers.full_image_url(self.guid)
  end

  def regenerate_thumbnail!
    ImageProcessingJob.perform_later self
  end

  def clean_up_character
    if self.deleted? or self.nsfw?
      Character.where(profile_image_id: self.id).update_all profile_image_id: nil
      Character.where(featured_image_id: self.id).update_all featured_image_id: nil
    end
  end

  def managed_by?(user)
    self.character.managed_by? user
  end

  def geometry
    Paperclip::Geometry.new width, height
  end

  def phash_distance
    attributes['phash_distance']
  end

  def recalculate_attachment_meta!
    return unless self.has_attribute? :image_meta and self.image_meta.nil?

    if self.image.respond_to? :reprocess_without_delay!
      self.image.reprocess_without_delay! :original
    else
      self.image.reprocess! :original
    end
  end

  private

  def adjust_source_url
    return unless source_url.present?
    self.source_url = 'http://' + source_url unless source_url =~ /\A[a-z]+:\/\//i
  end

  def log_activity
    if Activity.exists?(activity: self, activity_method: 'create')
      return
    end

    Activity.create activity: self,
                    user_id: self.character.user_id,
                    character_id: self.character_id,
                    created_at: self.created_at,
                    activity_method: 'create'
  end

  def contemplate_reprocessing
    if saved_change_to_gravity? or saved_change_to_watermark?
      self.update_column(:image_processing, true)
      ImageProcessingJob.perform_later(self)
    end
  end

  def sync_hashtags
    old_tags = hashtags.collect {|t| t.tag}
    new_tags = []

    unless caption.blank?
      caption.scan(/#(\w+)/) do |tag|
        new_tags.push tag[0]&.downcase
      end
    end

    new_tags.uniq!
    remove = old_tags - new_tags
    add = new_tags - old_tags

    remove.each do |tag|
      hashtags.delete(Media::Hashtag[tag])
    end

    add.each do |tag|
      hashtags.push(Media::Hashtag[tag])
    end
  end

  def delayed_complete
    schedule_phash_job
    send_processing_notification
    log_activity
  end

  def schedule_phash_job
    if self.image_updated_at_changed?
      Rails.logger.info("Scheduling pHash update.")
      ImagePhashJob.perform_later(self)
    end
  end

  def send_processing_notification
    Rails.logger.info("Post-processing complete, sending push notification.")
    trigger! "imageProcessingComplete",
             { imageId: self.guid },
             self
  end
end
