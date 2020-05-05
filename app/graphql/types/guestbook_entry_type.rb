module Types
  GuestbookEntryType = GraphQL::ObjectType.define do
    name 'GuestbookEntry'
    interfaces [Interfaces::ApplicationRecordInterface]

    field :character, Types::CharacterType
    field :author, Types::UserType
    field :author_character, Types::CharacterType
    field :message, types.String
  end
end