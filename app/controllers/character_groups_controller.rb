class CharacterGroupsController < ApplicationController
  before_action :get_character_group, only: [:update]

  def create
    @character_group = CharacterGroup.create group_params
    respond_with @character_group, location: nil, serializer: CharacterGroupSerializer
  end

  def update
    if params[:character_id]
      @character_group.characters << current_user.characters.find_by!(slug: params[:character_id].downcase)
      @character_group.save
    else
      @character_group.update_attributes group_params
    end

    respond_with @character_group, location: nil, serializer: CharacterGroupSerializer
  end

  def destroy
    @character_group.destroy
    respond_with @character_group, location: nil, serializer: CharacterGroupSerializer
  end

  private

  def get_character_group
    head :unauthorized and return false unless signed_in?
    current_user.character_groups.find_by slug: params[:id].downcase
  end

  def group_params
    params.require(:character_group)
          .permit(
              :name,
              :hidden,
              :row_order_position
          )
          .merge(
              user: current_user
          )
  end
end
