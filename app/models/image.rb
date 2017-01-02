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
#

class Image < ApplicationRecord
  include HasGuid
  include RankedModel

  belongs_to :character

  has_attached_file :image, default_url: '/assets/unsplash/fox.jpg'

  validates_attachment :image, presence: true,
                       content_type: { content_type: /image\/*/ },
                       size: { in: 0..10.megabytes }

  has_guid
  ranks :row_order
end
