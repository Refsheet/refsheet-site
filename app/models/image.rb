# == Schema Information
#
# Table name: images
#
#  id                 :integer          not null, primary key
#  character_id       :integer
#  artist_id          :integer
#  caption            :string
#  source_url         :string
#  image_file_name    :string
#  image_content_type :string
#  image_file_size    :integer
#  image_updated_at   :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  row_order          :integer
#  guid               :string
#  gravity            :string
#  nsfw               :boolean
#  hidden             :boolean
#  gallery_id         :integer
#  deleted_at         :datetime
#  title              :string
#  background_color   :string
#  comments_count     :integer
#  favorites_count    :integer
#
# Indexes
#
#  index_images_on_guid  (guid)
#

# Should me larger than 1280px in both dimensions,
# should be no more than 25MB
# TODO - This will be refactored to be an STI class of Media
class Image < ApplicationRecord # < Media
  include HasGuid
  include RankedModel

  belongs_to :character, inverse_of: :images
  has_one :user, through: :character
  has_many :favorites, foreign_key: :media_id, class_name: Media::Favorite, dependent: :destroy
  has_many :comments, foreign_key: :media_id, class_name: Media::Comment, dependent: :destroy

  # Requires this to eager load the news feed:
  has_many :activities, as: :activity, dependent: :destroy

  SIZE = {
      thumbnail: 320,
      small: 427,
      medium: 854,
      large: 1280
  }

  has_attached_file :image,
                    default_url: '/assets/default.png',
                    styles: {
                        thumbnail: '',
                        small: "#{SIZE[:small]}x>",
                        small_square: '',
                        medium: "#{SIZE[:medium]}x>",
                        medium_square: '',
                        large: "#{SIZE[:large]}x>",
                        large_square: ''
                    },
                    s3_permissions: {
                        original: :private
                    },
                    convert_options: {
                       thumbnail:     -> (i) { "-resize '#{SIZE[:thumbnail]}x#{SIZE[:thumbnail]}^' +repage -gravity '#{i.gravity}' -crop '#{SIZE[:thumbnail]}x#{SIZE[:thumbnail]}+0+0'" },
                       small_square:  -> (i) { "-resize '#{SIZE[:small]}x#{SIZE[:small]}^' +repage -gravity '#{i.gravity}' -crop '#{SIZE[:small]}x#{SIZE[:small]}+0+0'" },
                       medium_square: -> (i) { "-resize '#{SIZE[:medium]}x#{SIZE[:medium]}^' +repage -gravity '#{i.gravity}' -crop '#{SIZE[:medium]}x#{SIZE[:medium]}+0+0'" },
                       large_square:  -> (i) { "-resize '#{SIZE[:large]}x#{SIZE[:large]}^' +repage -gravity '#{i.gravity}' -crop '#{SIZE[:large]}x#{SIZE[:large]}+0+0'" }
                    }


  validates_attachment :image, presence: true,
                       content_type: { content_type: /image\/*/ },
                       size: { in: 0..25.megabytes }

  validates_format_of :background_color,
                      with: ColorScheme::COLOR_MATCH,
                      message: 'must be RGB, HSL or Hex code',
                      allow_blank: true,
                      if: -> { background_color_changed? }

  has_guid
  ranks :row_order, with_same: :character_id
  acts_as_paranoid

  before_validation :adjust_source_url
  after_save :clean_up_character
  after_destroy :clean_up_character
  after_create :log_activity

  scoped_search on: [:caption, :image_file_name]
  scoped_search relation: :character, on: [:name, :species]

  scope :unflagged, -> { where(nsfw: nil) }
  scope :sfw, -> { where(nsfw: [false, nil]) }
  scope :nsfw, -> { where(nsfw: true) }
  scope :visible, -> { where(hidden: [false, nil]) }

  scope :visible_to, -> (user) {
    if user
      joins(:character).
      where <<-SQL.squish, user.id, true, true
        characters.user_id = ? OR ( characters.hidden != ? AND images.hidden != ? )
      SQL
    else
      joins(:character).
      where('characters.hidden != ?', true).
      visible
    end
  }

  def gravity
    super || 'center'
  end

  def title
    super || "Image of #{self.character&.name || 'Anonymous'}"
  end

  def background_color
    color = if super
              super
            elsif self.character&.color_scheme
              c = self.character.color_scheme.color_data['image-background']
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

  private

  def adjust_source_url
    return unless source_url.present?
    self.source_url = 'http://' + source_url unless source_url =~ /\A[a-z]+:\/\//i
  end

  def log_activity
    Activity.create activity: self, user_id: self.character.user_id, character_id: self.character_id, created_at: self.created_at, activity_method: 'create'
  end
end
