class CharacterGroupsController < ApplicationController
  before_action :get_character_group, only: [:update, :destroy]

  respond_to :json

  def create
    @character_group = CharacterGroup.create group_params
    respond_with @character_group, location: nil, json: @character_group, serializer: CharacterGroupSerializer
  end

  def update
    @character_group.update_attributes group_params
    respond_with @character_group, location: nil, json: @character_group, serializer: CharacterGroupSerializer
  end

  def destroy
    @character_group.destroy
    respond_with @character_group, location: nil, json: @character_group, serializer: CharacterGroupSerializer
  end

  private

  def get_character_group
    head :unauthorized and return false unless signed_in?
    @character_group = current_user.character_groups.find_by! slug: params[:id].downcase
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
