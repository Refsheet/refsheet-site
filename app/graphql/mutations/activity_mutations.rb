class Mutations::ActivityMutations < Mutations::ApplicationMutation
  action :index do
    type types[Types::ActivityType]

    argument :since, types.Int
    argument :page, types.Int
    argument :type, types.String
  end

  def index
    current_user.activity.page(params[:page] || 1)
  end

  action :create do
    type Types::ActivityType

    argument :character_id, types.ID
    argument :comment, types.String
  end

  def create
    @activity = Activity.create!(activity_params)
  end

  private

  def activity_params
    user = context.current_user.call
    character = nil

    if params[:character_id].present?
      character = user.characters.find_by!(guid: params[:character_id])
    end

    params
        .permit(:comment)
        .merge(
            user: user,
            character: character,
            activity_method: 'create'
        )
  end
end