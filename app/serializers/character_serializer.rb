class CharacterSerializer < ActiveModel::Serializer
  include RichTextHelper
  include GravatarImageTag
  include Rails.application.routes.url_helpers

  attributes :name, :slug, :shortcode, :profile, :path, :user_id, :gender,
             :species, :height, :weight, :body_type, :personality, :special_notes, :link,
             :special_notes_html, :profile_html, :likes, :likes_html, :dislikes, :dislikes_html,
             :user_avatar_url, :user_name, :id, :created_at

  has_many :swatches, serializer: SwatchSerializer
  has_one  :featured_image, serializer: CharacterImageSerializer
  has_one  :profile_image, serializer: CharacterImageSerializer
  has_one  :color_scheme, serializer: ColorSchemeSerializer
  has_one  :pending_transfer, serializer: CharacterTransferSerializer

  def swatches
    object.swatches.rank(:row_order)
  end

  def path
    user_character_path object.user, object
  end

  def link
    "/#{object.user.username}/#{object.slug}"
  end

  def user_id
    object.user.username
  end

  def user_name
    object.user.name
  end

  def user_avatar_url
    gravatar_image_url object.user.email
  end

  def special_notes_html
    linkify object.special_notes
  end

  def profile_html
    linkify object.profile
  end

  def likes_html
    linkify object.likes
  end

  def dislikes_html
    linkify object.dislikes
  end

  def created_at
    object.created_at.strftime '%d %b %Y'
  end
end
