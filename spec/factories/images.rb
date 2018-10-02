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
#  image_file_size         :integer
#  image_updated_at        :datetime
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  row_order               :integer
#  guid                    :string
#  gravity                 :string
#  nsfw                    :boolean
#  hidden                  :boolean          default("false")
#  gallery_id              :integer
#  deleted_at              :datetime
#  title                   :string
#  background_color        :string
#  comments_count          :integer
#  favorites_count         :integer
#  image_meta              :text
#  image_processing        :boolean          default("false")
#  image_direct_upload_url :string
#
# Indexes
#
#  index_images_on_guid  (guid)
#

FactoryGirl.define do
  factory :image do
    character
    caption { Faker::Lorem.sentence }
    image { File.new("app/assets/images/default.png") }

    trait :nsfw do
      nsfw true
    end
  end
end
