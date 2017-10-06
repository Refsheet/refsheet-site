class Account::ActivitiesController < AccountController
  def index
    @activities = filter_scope Activity.eager_loaded
    render api_collection_response @activities, each_serializer: ActivitySerializer, root: 'activity'
  end
end
