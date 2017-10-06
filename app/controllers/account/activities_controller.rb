class Account::ActivitiesController < AccountController
  def index
    @activities = [
        {
            activity_type: 'Image',
            activity_method: 'create',
            activity_field: nil,
            timestamp: 1.day.ago.to_i,
            user: UserIndexSerializer.new(current_user),
            character: ImageCharacterSerializer.new(current_user.characters.first),
            activity: ImageSerializer.new(current_user.characters.first.images.first, scope: view_context)
        },
        {
            activity_type: 'Forum::Discussion',
            activity_method: 'create',
            activity_field: nil,
            timestamp: 1.day.ago.to_i,
            user: UserIndexSerializer.new(current_user),
            character: nil,
            activity: Forum::ThreadSerializer.new(Forum::Discussion.first)
        },
        {
            activity_type: 'Character',
            activity_method: 'create',
            activity_field: nil,
            timestamp: 1.day.ago.to_i,
            user: UserIndexSerializer.new(current_user),
            character: nil,
            activity: CharacterSerializer.new(current_user.characters.first)
        },
        {
            activity_type: 'Character',
            activity_method: 'update',
            activity_field: 'about',
            timestamp: 1.day.ago.to_i,
            user: UserIndexSerializer.new(current_user),
            character: ImageCharacterSerializer.new(current_user.characters.first),
            activity: CharacterSerializer.new(current_user.characters.first)
        },
        {
            activity_type: 'Comment',
            activity_method: 'create',
            activity_field: nil,
            timestamp: 1.day.ago.to_i,
            user: UserIndexSerializer.new(current_user),
            character: nil,
            activity: Media::CommentSerializer.new(Media::Comment.first)
        }
    ]

    @activities = filter_scope Activity.eager_loaded
    render api_collection_response @activities, each_serializer: ActivitySerializer, root: 'activity'
  end
end
