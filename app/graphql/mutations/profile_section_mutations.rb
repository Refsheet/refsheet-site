class Mutations::ProfileSectionMutations < Mutations::ApplicationMutation
  before_action :get_profile_section, only: [:update, :delete]
  before_action :get_character, only: [:create]

  action :create do
    type Types::ProfileSectionType

    argument :characterId, !types.ID
    argument :createAfterSectionId, types.ID
  end

  def create
    position = :last

    if params[:createAfterSectionId]
      previous_section = @character.profile_sections.find_by(id: params[:createAfterSectionId])
      rank = previous_section.row_order_rank
      position = rank + 1 unless rank.nil?
    end

    @profile_section = @character.profile_sections.create row_order_position: position
  end

  action :update do
    type Types::ProfileSectionType

    argument :id, !types.ID
    argument :title, types.String
    argument :row_order_position, types.String
  end

  def update
    @profile_section.update_attributes! profile_section_params
    @profile_section
  end

  action :delete do
    type Types::ProfileSectionType

    argument :id, !types.ID
  end

  def delete
    @profile_section.destroy
    @profile_section
  end

  private

  def profile_section_params
    params.permit(:title, :row_order_position)
  end

  def get_character
    @character = Character.find_by!(shortcode: params[:characterId])
    authorize! @character.managed_by? current_user
  end

  def get_profile_section
    @profile_section = Characters::ProfileSection.find params[:id]
    authorize! @profile_section.character.managed_by? current_user
  end
end
