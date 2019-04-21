class Mutations::CharacterMutations < Mutations::ApplicationMutation
  before_action :get_character, only: [:update, :convert]

  action :update do
    type Types::CharacterType

    argument :id, !types.ID

    argument :name, types.String
    argument :species, types.String
    argument :special_notes, types.String
  end

  def update
    @character.update_attributes! update_params
    @character
  end

  action :convert do
    type Types::CharacterType
    argument :id, !types.ID
  end

  def convert
    ConvertProfileV2Job.perform_now(@character)
    @character
  end

  action :search do
    type types[Types::CharacterType]

    argument :username, type: types.String
    argument :slug, type: types.String
  end

  def search
    q = params[:slug].downcase + '%'
    scope = User.lookup(params[:username]).characters
    scope.where('LOWER(characters.slug) LIKE ? OR LOWER(characters.name) LIKE ?', q, q).limit(10).order(:name)
  end

  private

  def get_character
    @character = Character.find_by! shortcode: params[:id]
    authorize! @character.managed_by? context.current_user.call
  end

  def update_params
    params.permit(
        :name,
        :species,
        :special_notes
    )
  end
end
