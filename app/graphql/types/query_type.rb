Types::QueryType = GraphQL::ObjectType.define do
  name "Query"
  # Add root-level fields here.
  # They will be entry points for queries on your schema.

  field :findUser, Types::UserType do
    argument :username, !types.String
    resolve -> (_obj, args, _cts) { User.lookup! args[:username] }
  end

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
      raise GraphQL::ExecutionError.new "Not authorized!" unless ctx[:current_user]

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

  field :getConversations, types[Types::ConversationType] do
    resolve -> (_obj, _args, ctx) {
      # scope = Conversation.all
      scope = Conversation.for(ctx[:current_user])
      scope.includes(:sender, :recipient)
    }
  end

  field :getMessages, types[Types::MessageType] do
    argument :conversationId, !types.ID

    resolve -> (_obj, args, ctx) {
      conversation = Conversation.for(ctx[:current_user]).find_by! guid: args[:conversationId]
      conversation.messages
    }
  end
end
