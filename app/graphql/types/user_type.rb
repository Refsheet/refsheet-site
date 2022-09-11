Types::UserType = GraphQL::ObjectType.define do
  extend Helpers::PrivateFields

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


  field :avatar_url, types.String do
    argument :style, types.String

    resolve -> (obj, args, _ctx) {
      obj.avatar_url(args[:style] || :thumbnail)
    }
  end

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

  field :is_blocked, types.Boolean do
    resolve -> (obj, _args, ctx) {
      obj.blocked_by? ctx[:current_user].call
    }
  end

  field :blocks, types.Boolean do
    resolve -> (obj, _args, ctx) {
      obj.blocked? ctx[:current_user].call
    }
  end

  field :characters, types[Types::CharacterType] do
    argument :group_id, types.ID

    resolve -> (obj, args, ctx) {
      scope = obj.characters.visible_to(ctx[:current_user].call).rank(:row_order)

      unless args[:group_id].nil?
        scope = scope.joins(:character_groups).where(character_groups: { slug: args[:group_id] })
      end

      scope
    }
  end

  field :character_groups, types[Types::CharacterGroupType] do
    resolve -> (obj, _args, _ctx) {
      obj.character_groups.rank(:row_order)
    }
  end

  field :link, types.String do
    resolve -> (obj, _args, _ctx) {
      "/#{obj.username}"
    }
  end

  field :apiKeys, types[Types::ApiKeyType] do
    resolve -> (obj, _args, ctx) {
      if ctx[:current_user].call&.id == obj.id
        obj.api_keys
      else
        []
      end
    }
  end

  # has_many :character_groups,
  #          serializer: CharacterGroupSerializer

  private_field :email, types.String
  private_field :unconfirmed_email, types.String
  private_field :support_pledge_amount, types.Int
  private_field :email_confirmed_at, types.Int
end
