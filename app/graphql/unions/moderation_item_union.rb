Unions::ModerationItemUnion = GraphQL::UnionType.define do
  name "ModerationItem"
  description "Various data attached to a particular moderation item"

  resolve_type -> (obj, _ctx) {
    case obj.class.name
      when 'Image'
        Types::ImageType
    end
  }

  possible_types [
      Types::ImageType
  ]
end
