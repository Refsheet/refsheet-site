class CharactersController < ApplicationController
  before_action :get_user
  before_action :get_character

  def show
    respond_to do |format|
      format.json { render json: @character, serializer: CharacterSerializer }
      format.html { render component: 'CharacterApp', characterPath: user_character_path(@character.user, @character) }
    end
  end

  private

  def get_user
    @user = User.find_by!('LOWER(users.username) = ?', params[:user_id].downcase)
  end

  def get_character
    @character = @user.characters.find_by!('LOWER(characters.url) = ?', params[:id].downcase)
  end
end
