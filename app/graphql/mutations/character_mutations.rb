class Mutations::CharacterMutations < Mutations::ApplicationMutation
  before_action :get_character

  action :update do
    type Types::CharacterType

    argument :id, !types.ID

    argument :name, types.String
  end

  def update
    @character.update_attributes update_params
    @character
  end

  private

  def get_character
    @character = Character.find_by! shortcode: params[:id]
    authorize! @character.managed_by? context.current_user
  end

  def update_params
    params.permit(:name)
  end
end
