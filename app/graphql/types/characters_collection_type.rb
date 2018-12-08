Types::CharactersCollectionType = GraphQL::ObjectType.define do
  name "CharactersCollection"

  field :total_pages, types.Int
  field :current_page, types.Int
  field :total_entries, types.Int
  field :count, types.Int

  field :characters, !types[Types::CharacterType] do
    resolve -> (scope, _args, _ctx) {
      scope
    }
  end
end
