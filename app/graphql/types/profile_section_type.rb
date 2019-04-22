Types::ProfileSectionType = GraphQL::ObjectType.define do
  name 'ProfileSection'

  field :id, !types.ID
  field :columns, !types[types.Int]
  field :title, types.String
  field :widgets, types[Types::WidgetType]
  field :row_order, types.Int
end
