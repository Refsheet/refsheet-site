def paginate_scope(scope, args)
  page = args[:page] || 1
  per_page = args[:per_page] || 30
  scope.paginate(page: page, per_page: per_page)
end

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

  field :searchForCharacter, Types::CharactersCollectionType do
    argument :query, !types.String
    argument :page, types.Int

    resolve -> (_obj, args, _ctx) {
      paginate_scope Character.search_for(args[:query]), args
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
      raise GraphQL::ExecutionError.new "Not authorized!" unless ctx[:current_user].call

      character = ctx[:current_user].call.characters.find(args[:characterId])

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

  field :getNotifications, Types::NotificationsCollectionType do
    resolve -> (_obj, _args, ctx) {
      Notification.for(ctx[:current_user].call)
    }
  end

  field :getConversations, types[Types::ConversationType] do
    resolve -> (_obj, _args, ctx) {
      # scope = Conversation.all
      scope = Conversation.for(ctx[:current_user].call)
      scope.includes(:sender, :recipient)
    }
  end

  field :getConversation, Types::ConversationType do
    argument :conversationId, !types.ID
    resolve -> (_obj, args, ctx) {
      scope = Conversation.for(ctx[:current_user].call)
      scope.find_by!(guid: args[:conversationId])
    }
  end

  field :getMessages, types[Types::MessageType] do
    argument :conversationId, !types.ID

    resolve -> (_obj, args, ctx) {
      conversation = Conversation.for(ctx[:current_user].call).find_by! guid: args[:conversationId]
      scope = conversation.messages
      scope.includes(:conversation, :user)
    }
  end

  field :chatCounts, Types::ChatCountType do
    resolve -> (_obj, _args, ctx) {
      Conversation.counts_for(ctx[:current_user].call)
    }
  end

  field :getSession, Types::SessionType, field: Mutations::SessionMutations::Show

  field :getMedia, Types::ImageType do
    argument :mediaId, !types.ID

    resolve -> (_obj, args, _ctx) {
      Image.find_by!(guid: args[:mediaId])
    }
  end

  #== AUTOCOMPLETE

  field :searchForUser, field: Mutations::UserMutations::Search
  field :searchForCharacter, field: Mutations::CharacterMutations::Search
  field :autocompleteHashtags, field: Mutations::MediaHashtagMutations::Autocomplete

  #== Forums

  field :getForums, field: Mutations::ForumMutations::Index
  field :getForum, field: Mutations::ForumMutations::Show
  field :getDiscussion, field: Mutations::ForumDiscussionMutations::Show

  #== Artists

  field :getArtist, field: Mutations::ArtistMutations::Show

  #== Media

  field :getComments, field: Mutations::MediaCommentMutations::Index
end
