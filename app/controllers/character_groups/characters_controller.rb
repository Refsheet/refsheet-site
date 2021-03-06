class CharacterGroups::CharactersController < ApplicationController
  before_action :get_group
  before_action :get_character

  respond_to :json

  def create
    if @group.characters.include? @character
      @group.characters.destroy @character
      respond_with @group, location: nil, json: @group, serializer: CharacterGroupSerializer
    else
      @group.characters << @character
      @group.save
      respond_with @group, location: nil, json: @group, serializer: CharacterGroupSerializer
    end
  end

  def destroy
    @group.characters.destroy @character
    @group.save
    respond_with @group, location: nil, json: @group, serializer: CharacterGroupSerializer
  end

  private

  def get_group
    head :unauthorized unless signed_in?
    @group = current_user.character_groups.find_by! slug: params[:character_group_id]
  end

  def get_character
    @character = current_user.characters.find_by! slug: params[:id]
  end
end
