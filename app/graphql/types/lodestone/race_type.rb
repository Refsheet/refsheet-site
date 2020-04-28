module Types
  module Lodestone
    RaceType = GraphQL::ObjectType.define do
      name "Lodestone_Race"
      interfaces [Interfaces::ApplicationRecordInterface]

      field :name, types.String
      field :lodestone_id, types.String
    end
  end
end