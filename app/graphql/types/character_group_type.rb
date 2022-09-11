Types::CharacterGroupType = GraphQL::ObjectType.define do
  name 'CharacterGroup'

  interfaces [Interfaces::ApplicationRecordInterface]

  field :slug, !types.ID
  field :row_order, !types.Int
  field :name, !types.String
  field :characters_count, !types.Int
  field :visible_characters_count, !types.Int
  field :hidden_characters_count, !types.Int

  field :characters, types[Types::CharacterType] do
    resolve -> (obj, _args, _ctx) {
      obj.characters.rank(:row_order)
    }
  end
end
