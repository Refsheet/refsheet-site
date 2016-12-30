class CharactersController < ApplicationController
  before_action :get_user
  before_action :get_character

  def show
    respond_to do |format|
      format.json { render json: @character, serializer: CharacterSerializer }
      format.html { render 'application/show' }
    end
  end

  def update
    if @character.update_attributes character_params
      render json: @character, each_serializer: CharacterSerializer
    else
      render json: { errors: @character.errors }, status: :bad_request
    end
  end

  private

  def get_user
    @user = User.find_by!('LOWER(users.username) = ?', params[:user_id].downcase)
  end

  def get_character
    @character = @user.characters.find_by!('LOWER(characters.url) = ?', params[:id].downcase)
  end

  def character_params
    params.require(:character).permit(:name, :nickname, :gender, :species, :height, :weight,
                                      :body_type, :personality, :special_notes,
                                      :featured_image_id, :profile_image_id)
  end
end
