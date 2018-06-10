Types::QueryType = GraphQL::ObjectType.define do
  name "Query"
  # Add root-level fields here.
  # They will be entry points for queries on your schema.

  field :getCharacter, Types::CharacterType do
    argument :id, !types.ID
    resolve -> (_obj, args, _ctx) { Character.find(args[:id]) }
  end

  field :getCharacterByUrl, Types::CharacterType do
    argument :username, !types.String
    argument :slug, !types.String

    resolve -> (_obj, args, _ctx) {
      User.lookup!(args[:username]).characters.lookup!(args[:slug])
    }
  end

  field :getNextModeration, Types::ModerationType do
    resolve -> (_obj, _args, _ctx) {
      ModerationReport.next
    }
  end
end
