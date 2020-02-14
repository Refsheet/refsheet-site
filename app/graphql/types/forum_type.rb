#  id          :integer          not null, primary key
#  name        :string
#  description :text
#  slug        :string
#  locked      :boolean
#  nsfw        :boolean
#  no_rp       :boolean
#
Types::ForumType = GraphQL::ObjectType.define do
  name 'Forum'

  interfaces [Interfaces::ApplicationRecordInterface]

  field :name, !types.String
  field :summary, !types.String
  field :description, types.String
  field :slug, types.String
  field :locked, types.Boolean
  field :nsfw, types.Boolean
  field :no_rp, types.Boolean
  field :system_owned, types.Boolean
  field :rules, types.String
  field :prepost_message, types.String
  field :is_open, types.Boolean

  field :member_count, types.Int
  field :discussion_count, types.Int

  field :owner, Types::UserType
  # field :fandom, Types::FandomType

  field :is_member, types.Boolean do
    resolve -> (obj, _args, ctx) {
      obj.has_member? ctx[:current_user].call
    }
  end

  field :discussions, types[Types::ForumDiscussionType] do
    argument :page, types.Int
    argument :sort, types.String
    argument :sticky, types.Boolean

    resolve -> (obj, args, ctx) {
      scope = obj.threads

      if args[:page]
        scope = scope.page(args[:page])
      end

      if args[:sort]
        scope = scope.order(created_at: :desc)
      else
        scope = scope.order(created_at: :desc)
      end

      if args[:sticky]
        scope = scope.sticky
      end

      # Eager Load
      scope = scope.with_unread_count(ctx[:current_user].call)
      scope = scope.with_last_post_at

      scope = scope.includes(:user, :character)

      scope
    }
  end
end
