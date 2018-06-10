Types::CharacterType = GraphQL::ObjectType.define do
  name 'Character'

  interfaces [Interfaces::ApplicationRecordInterface]

  field :custom_attributes, types[Types::AttributeType]
  field :dislikes, types.String
  field :dislikes_html, types.String
  field :featured_image, Types::ImageType
  field :hidden, types.Boolean
  field :images, types[Types::ImageType]
  field :likes, types.String
  field :likes_html, types.String
  field :name, !types.String
  field :nsfw, types.Boolean
  field :profile, types.String
  field :profile_html, types.String
  field :profile_image, Types::ImageType
  field :shortcode, types.String
  field :slug, !types.String
  field :special_notes, types.String
  field :special_notes_html, types.String
  field :species, types.String
  field :swatches, types[Types::SwatchType]
  field :user, Types::UserType
  field :username, !types.String

  field :profile_sections, types[Types::ProfileSectionType] do
    resolve -> (obj, _args, _ctx) {
      profile_widget = OpenStruct.new type: 'RichText',
                                      id: SecureRandom.hex,
                                      column: 0,
                                      title: nil,
                                      data: {content: obj.profile, content_html: obj.profile_html}

      profile_section = {
          id: SecureRandom.hex,
          title: "About #{obj.name}",
          columns: [12],
          widgets: [
              profile_widget
          ]
      }

      likes_widget = OpenStruct.new type: 'RichText',
                                    id: SecureRandom.hex,
                                    column: 0,
                                    title: 'Likes',
                                    data: {content: obj.likes, content_html: obj.likes_html}

      dislikes_widget = OpenStruct.new type: 'RichText',
                                       id: SecureRandom.hex,
                                       column: 1,
                                       title: 'Dislikes',
                                       data: {content: obj.dislikes, content_html: obj.dislikes_html}

      like_dislike_section = {
          id: SecureRandom.hex,
          title: nil,
          columns: [6, 6],
          widgets: [
              likes_widget,
              dislikes_widget
          ]
      }

      [
          OpenStruct.new(profile_section),
          OpenStruct.new(like_dislike_section)
      ]
    }
  end

  field :theme, Types::ThemeType, property: :color_scheme

  # has_one :pending_transfer, serializer: CharacterTransferSerializer
end
