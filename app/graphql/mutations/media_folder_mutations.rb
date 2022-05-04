class Mutations::MediaFolderMutations < Mutations::ApplicationMutation
  before_action :get_character

  action :create do
    type Types::MediaFolderType
    argument :name, !types.String
    argument :slug, types.String
    argument :characterId, !types.ID
  end

  def create
    @folder = Media::Folder.new create_folder_params
    authorize @folder
    @folder.save
    @folder
  end

  action :destroy do
    type Types::MediaFolderType
    argument :id, !types.ID
  end

  def destroy
    @folder = Media::Folder.find_by! guid: params[:id]
    authorize @folder
    @folder.destroy
    @folder
  end

  private

  def get_character
    @character = Character.find_by! guid: params[:characterId]
  end

  def create_folder_params
    params.permit(:name, :slug).merge(character: @character, user: current_user)
  end
end
