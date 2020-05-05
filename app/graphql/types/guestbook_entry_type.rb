module Types
  GuestbookEntryType = GraphQL::ObjectType.define do
    name 'GuestbookEntry'
    interfaces [Interfaces::ApplicationRecordInterface]


  end
end