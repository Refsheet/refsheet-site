Unions::WidgetDataUnion = GraphQL::UnionType.define do
  name "WidgetData"
  description "Various data attached to a particular widget"

  resolve_type -> (obj, _ctx) {
    case obj[:_data_type]
      when 'RichText'
        Types::Widgets::RichTextType
      else
        Types::Widgets::JsonType
    end
  }

  possible_types [
      Types::Widgets::RichTextType
  ]
end
