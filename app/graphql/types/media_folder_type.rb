Types::MediaFolderType = GraphQL::ObjectType.define do
  extend Helpers::PrivateFields

  name "MediaFolder"
  interfaces [Interfaces::ApplicationRecordInterface]

  field :name, types.String
  field :description, types.String
  field :user, Types::UserType
  field :character, Types::CharacterType
  field :parent, Types::MediaFolderType
  field :featured_media, Types::ImageType

  field :children, types[Types::MediaFolderType] do
    resolve -> (scope, _args, _ctx) {
      scope.ranked(:row_order)
    }
  end

  field :media, types[Types::ImageType] do
    resolve -> (scope, _args, _ctx) {
      scope.ranked(:row_order)
    }
  end

  field :media_count, types.Int
  field :is_hidden, types.Boolean
  field :is_nsfw, types.Boolean
  field :is_password_protected, types.Boolean
  field :guid, types.ID
  field :slug, types.String

  private_field :password, types.String
end
