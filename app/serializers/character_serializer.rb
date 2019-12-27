# == Schema Information
#
# Table name: characters
#
#  id                :integer          not null, primary key
#  user_id           :integer
#  name              :string
#  slug              :string
#  shortcode         :string
#  profile           :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  gender            :string
#  species           :string
#  height            :string
#  weight            :string
#  body_type         :string
#  personality       :string
#  special_notes     :text
#  featured_image_id :integer
#  profile_image_id  :integer
#  likes             :text
#  dislikes          :text
#  color_scheme_id   :integer
#  nsfw              :boolean
#  hidden            :boolean          default(FALSE)
#  secret            :boolean
#  row_order         :integer
#  deleted_at        :datetime
#  custom_attributes :text
#  version           :integer          default(1)
#

class CharacterSerializer < ActiveModel::Serializer
  include RichTextHelper
  include GravatarImageTag
  include Rails.application.routes.url_helpers

  attributes :name, :slug, :shortcode, :profile, :path, :user_id, :gender,
             :species, :height, :weight, :body_type, :personality, :special_notes, :link,
             :special_notes_html, :profile_html, :likes, :likes_html, :dislikes, :dislikes_html,
             :user_avatar_url, :user_name, :id, :created_at, :followed, :hidden, :nsfw,
             :custom_attributes, :profile_sections, :version, :real_id

  has_many :swatches, serializer: SwatchSerializer
  has_one :featured_image, serializer: CharacterImageSerializer
  has_one :profile_image, serializer: CharacterImageSerializer
  has_one :color_scheme, serializer: ColorSchemeSerializer
  has_one :pending_transfer, serializer: CharacterTransferSerializer
  has_many :images, serializer: ImageSerializer

  def profile_sections
    [
        {
            id: "df56",
            row_order: 1,
            columns: [
                {
                    id: "ad47",
                    column_order: 1,
                    width: 3,
                    widgets: [
                        {
                            id: "ffcc",
                            type: 'RichText',
                            title: 'About Page Sections',
                            data: {
                                content: <<-MARKDOWN.squish,
                              # This is a Page Section!
                              
                              It's very fancy, you know.
                                MARKDOWN

                                content_html: <<-HTML.squish
                              <p>They're very fancy, you know.</p>
                              <ul>
                                <li>This section is a Markdown section,</li>
                                <li>And you can put whatever you want in it.</li>
                              </ul>
                                HTML
                            }
                        },
                        {
                            id: "ffcd",
                            type: 'Image',
                            title: 'This is a cat.',
                            data: {
                                image_src: 'https://loremflickr.com/640/480/fursuit',
                                width: 640,
                                height: 480
                            }
                        }
                    ]
                },
                {
                    id: "cd52",
                    column_order: 6,
                    width: 6,
                    widgets: [
                        {
                            id: "fa56",
                            type: 'YouTube',
                            data: {
                                video_url: "https://www.youtube.com/watch?v=UbQgXeY_zi4"
                            }
                        }
                    ]
                },
                {
                    id: "ab12",
                    column_order: 3,
                    width: 3,
                    widgets: [
                        {
                            id: "dac4",
                            type: 'Image',
                            data: {
                                image_src: 'http://mypa.ws/paws.jpg',
                                alt: 'Paws!',
                                caption: "The Caracal has wonderful, very lovely little coffee beans."
                            }
                        }
                    ]
                }
            ]
        }
    ]
  end

  def id
    object.slug
  end

  def real_id
    object.id
  end

  def custom_attributes
    object.custom_attributes&.as_json
  end

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

  def followed
    scope.current_user&.following? object.user if scope&.respond_to? :current_user
  end
end
