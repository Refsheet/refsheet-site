Types::UserType = GraphQL::ObjectType.define do
  name "User"
  interfaces [Interfaces::ApplicationRecordInterface]

  field :username, types.String
  field :name, types.String
  field :profile, types.String
  field :profile_html, types.String
  field :characters_count, types.String
  field :is_admin, types.Boolean
  field :is_patron, types.Boolean
  field :is_moderator, types.Boolean
  field :is_supporter, types.Boolean

  field :avatar_url, types.String
  field :profile_image_url, types.String

  field :is_managed, types.Boolean do
    resolve -> (obj, _args, ctx) {
      obj == ctx[:current_user].call
    }
  end

  field :is_followed, types.Boolean do
    resolve -> (obj, _args, ctx) {
      obj.followed_by? ctx[:current_user].call
    }
  end

  field :characters, types[Types::CharacterType] do
    resolve -> (obj, _args, ctx) {
      obj.characters.visible_to(ctx[:current_user].call).rank(:row_order)
    }
  end

  # has_many :character_groups,
  #          serializer: CharacterGroupSerializer
end
