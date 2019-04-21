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

class ImageSerializer < ActiveModel::Serializer
  include RichTextHelper
  include SessionHelper
  include Rails.application.routes.url_helpers

  attributes :id,
             :title,
             :caption,
             :url,
             :path,
             :post_date,
             :caption_html,
             :background_color,
             :nsfw,
             :hidden,
             :small,
             :small_square,
             :medium,
             :medium_square,
             :large,
             :large_square,
             :user_id,
             :gravity,
             :source_url,
             :source_url_display,
             :is_favorite,
             :favorites_count,
             :comments_count,
             :aspect_ratio,
             :watermark,
             :image_phash

  has_one :character, serializer: ImageCharacterSerializer
  has_many :favorites, serializer: Media::FavoriteSerializer
  has_many :comments, serializer: Media::CommentSerializer

  def aspect_ratio
    if object.image_meta
      object.aspect_ratio
    else
      1
    end
  end

  def id
    object.guid
  end

  def user_id
    object.character.user.username
  end

  def url
    object.image&.url(:large)
  end

  def small
    object.image&.url(:small)
  end

  def small_square
    object.image&.url(:small_square)
  end

  def medium
    object.image&.url(:medium)
  end

  def medium_square
    object.image&.url(:medium_square)
  end

  def large
    object.image&.url(:large)
  end

  def large_square
    object.image&.url(:large_square)
  end

  def path
    image_path object
  end

  def post_date
    object.created_at.strftime('%B %-d, %Y')
  end

  def caption_html
    linkify object.caption, markdown: false
  end

  def is_favorite
    object.favorites.any? { |f| f.user == current_user } if signed_in?
  end

  def session
    scope.session
  end

  def image_phash
    object.image_phash
  end
end
