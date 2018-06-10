Types::SwatchType = GraphQL::ObjectType.define do
  name "Swatch"
  interfaces [Interfaces::ApplicationRecordInterface]

  field :name, types.String
  field :color, types.String
  field :notes, types.String
end
