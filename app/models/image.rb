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
#

# Should me larger than 1280px in both dimensions,
# should be no more than 25MB
class Image < ApplicationRecord
  include HasGuid
  include RankedModel

  belongs_to :character, inverse_of: :images
  has_one :user, through: :character

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

  has_guid
  ranks :row_order
  acts_as_paranoid

  after_save :clean_up_character

  scoped_search on: [:caption, :image_file_name]
  scoped_search in: :character, on: [:name, :species]

  scope :sfw, -> { where(nsfw: [false, nil]) }
  scope :nsfw, -> { where(nsfw: true) }
  scope :visible, -> { where(hidden: [false, nil]) }

  def gravity
    super || 'center'
  end

  def source_url_display
    return nil unless self.source_url.present?
    uri = URI.parse(self.source_url)
    path_part = uri.path.split('/').last
    filler = ('/' + path_part == uri.path ? '' : '.../')

    "#{uri.host}/#{filler}#{path_part}"
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
end
