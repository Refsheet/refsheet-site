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

  field :id, !types.ID
  field :name, !types.String
  field :description, types.String
  field :slug, types.String
  field :locked, types.Boolean
  field :nsfw, types.Boolean
  field :no_rp, types.Boolean
  field :system_owned, types.Boolean

  field :discussions, types[Types::ForumDiscussionType] do
    argument :page, types.Int
    argument :sort, types.String

    resolve -> (obj, args, _ctx) {
      scope = obj.threads

      if args[:page]
        scope = scope.page(args[:page])
      end

      if args[:sort]
        scope = scope.order(created_at: :desc)
      else
        scope = scope.order(created_at: :desc)
      end

      scope
    }
  end
end
