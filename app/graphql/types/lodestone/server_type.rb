module Types
  module Lodestone
    ServerType = GraphQL::ObjectType.define do
      name "Lodestone_Server"
      interfaces [Interfaces::ApplicationRecordInterface]

      field :name, types.String
      field :datacenter, types.String
      field :lodestone_id, types.String
    end
  end
end