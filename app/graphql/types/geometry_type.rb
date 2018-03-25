Types::GeometryType = GraphQL::ObjectType.define do
  name "Geometry"

  field :width, !types.Int
  field :height, !types.Int
end
