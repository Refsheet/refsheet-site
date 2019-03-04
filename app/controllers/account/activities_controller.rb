class Account::ActivitiesController < AccountController
  around_action :use_read_replica, only: [:index]

  def index
    @activities = filter_scope Activity.feed_for(current_user).eager_loaded

    filters = {
        character: 'Character',
        image: 'Image',
        forum: 'Forum::Discussion',
        comment: 'Media::Comment',
        marketplace: 'Item'
    }

    if params[:filter] and (filter = filters[params[:filter].downcase.to_sym])
      @activities = @activities.where('activities.activity_type' => filter)
    end

    render api_collection_response @activities, each_serializer: ActivitySerializer, root: 'activity'
  end
end
