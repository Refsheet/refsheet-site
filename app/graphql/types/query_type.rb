Types::QueryType = GraphQL::ObjectType.define do
  name "Query"
  # Add root-level fields here.
  # They will be entry points for queries on your schema.

  field :getCharacter, Types::CharacterType do
    argument :id, !types.ID
    resolve -> (_obj, args, _ctx) { Character.find(args[:id]) }
  end

  field :getCharacterByUrl, Types::CharacterType do
    argument :username, !types.String
    argument :slug, !types.String

    resolve -> (_obj, args, _ctx) {
      User.lookup!(args[:username]).characters.lookup!(args[:slug])
    }
  end

  field :getNextModeration, Types::ModerationType do
    resolve -> (_obj, _args, _ctx) {
      ModerationReport.next
    }
  end

  field :getImageUploadToken, Types::ImageUploadTokenType do
    argument :characterId, !types.ID

    resolve -> (_obj, args, ctx) {
      raise GraphQL::Error.new "Not authorized!" unless ctx[:current_user]

      character = ctx[:current_user].characters.find(args[:characterId])

      presigned_post = character.images.new.image_presigned_post

      clean_keys = presigned_post
          .fields
          .transform_keys { |k| k.to_s.gsub(/^x-amz-/, 'x_amz_').to_sym }
          .merge(
              url: presigned_post.url
          )

      OpenStruct.new clean_keys
    }
  end
end
