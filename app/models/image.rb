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
#

# Should me larger than 854px in both dimensions,
# should be no more than 20MB
class Image < ApplicationRecord
  include HasGuid
  include RankedModel

  belongs_to :character

  has_attached_file :image,
                    default_url: '/assets/default.png',
                    styles: {
                        thumbnail: "320x320^",
                        small: "427x427^",
                        medium: "854x854^",
                        large: "1280x>"
                    },
                    s3_permissions: {
                        original: :private
                    },
                    convert_options: {
                       thumbnail: -> (i) { "-gravity #{i.gravity} -thumbnail 320x320^ -extent 320x320" },
                       small: -> (i) { "-gravity #{i.gravity} -thumbnail 427x427^ -extent 427x427" },
                       medium: -> (i) { "-gravity #{i.gravity} -thumbnail 854x854^ -extent 854x854" },
                    }


  validates_attachment :image, presence: true,
                       content_type: { content_type: /image\/*/ },
                       size: { in: 0..25.megabytes }

  has_guid
  ranks :row_order

  def gravity
    super || 'center'
  end

  def source_url_display
    return nil unless self.source_url.present?
    uri = URI.parse(self.source_url)
    path_part = uri.path.split('/').last
    filler = path_part == uri.path ? '' : '.../'

    "#{uri}/#{filler}#{path_part}"
  end

  def regenerate_thumbnail!
    self.image.reprocess!
  end
end
