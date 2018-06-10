Types::ImageType = GraphQL::ObjectType.define do
  name "Image"
  interfaces [Interfaces::ApplicationRecordInterface]

  field :title, types.String
  field :nsfw, types.Boolean
  field :hidden, types.Boolean
  field :caption, types.String
  field :caption_html, types.String
  field :source_url, types.String
  field :source_url_display, types.String
  field :background_color, types.String
  field :aspect_ratio, types.Float
  field :width, types.Int
  field :height, types.Int
  field :gravity, types.String
  field :favorites_count, types.Int
  field :comments_count, types.Int

  field :url, Types::ImageUrlType, property: :image
  field :size, Types::ImageSizeType, property: :image

  field :is_favorite, types.Boolean do
    resolve -> (obj, _args, ctx) {
      obj.favorites.by? ctx[:current_user]
    }
  end

  field :is_managed, types.Boolean do
    resolve -> (obj, _args, ctx) {
      obj.managed_by? ctx[:current_user]
    }
  end

  field :character, -> { Types::CharacterType }
  # has_one :character, serializer: ImageCharacterSerializer
  # has_many :favorites, serializer: Media::FavoriteSerializer
  # has_many :comments, serializer: Media::CommentSerializer
end
