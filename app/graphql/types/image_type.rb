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
  field :image_processing, types.Boolean
  field :image_processing_error, types.String
  field :watermark, types.Boolean

  field :is_v2_image, types.Boolean do
    resolve -> (obj, _args, _ctx) {
      obj.upload.attached?
    }
  end

  field :url, Types::ImageUrlType, property: :active_image
  field :size, Types::ImageSizeType, property: :active_image
  field :download_link, types.String

  field :is_favorite, types.Boolean do
    resolve -> (obj, _args, ctx) {
      obj.favorites.by? ctx[:current_user].call
    }
  end

  field :is_managed, types.Boolean do
    resolve -> (obj, _args, ctx) {
      obj.managed_by? ctx[:current_user].call
    }
  end

  field :character, Types::CharacterType
  field :character_id, types.ID

  field :favorites, types[Types::MediaFavoriteType]
  field :comments, types[Types::MediaCommentType]
  field :tags, types[Types::MediaTagType]
  field :hashtags, types[Types::MediaHashtagType]
end
