class Mutations::ProfileSectionMutations < Mutations::ApplicationMutation
  before_action :get_profile_section

  action :update do
    type Types::ProfileSectionType

    argument :id, !types.ID
    argument :title, types.String
  end

  def update
    @profile_section.update_attributes! profile_section_params
    @profile_section
  end

  private

  def profile_section_params
    params.permit(:title)
  end

  def get_profile_section
    @profile_section = Characters::ProfileSection.find params[:id]
    authorize! @profile_section.character.managed_by? current_user
  end
end
