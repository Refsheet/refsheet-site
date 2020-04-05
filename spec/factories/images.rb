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
#  index_images_on_custom_watermark_id  (custom_watermark_id)
#  index_images_on_guid                 (guid)
#

FactoryBot.define do
  factory :image do
    character
    caption { Faker::Lorem.sentence }
    image { asset "fox.jpg" }

    trait :nsfw do
      nsfw { true }
    end
  end
end
