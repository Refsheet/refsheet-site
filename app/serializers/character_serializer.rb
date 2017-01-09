class CharacterSerializer < ActiveModel::Serializer
  include RichTextHelper
  include Rails.application.routes.url_helpers

  attributes :name, :slug, :shortcode, :profile, :path, :user_id, :gender,
             :species, :height, :weight, :body_type, :personality, :special_notes, :link,
             :special_notes_html

  has_many :swatches, serializer: SwatchSerializer
  has_one  :featured_image, serializer: CharacterImageSerializer
  has_one  :profile_image, serializer: CharacterImageSerializer

  def swatches
    object.swatches.rank(:row_order)
  end

  def path
    user_character_path object.user, object
  end

  def link
    "#{object.user.username}/#{object.slug}"
  end

  def user_id
    object.user.username
  end

  def special_notes_html
    linkify object.special_notes
  end
end
