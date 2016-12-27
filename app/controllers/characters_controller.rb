class CharactersController < ApplicationController
  before_action :get_user
  before_action :get_character

  def show
    respond_to do |format|
      format.json { render json: @character }
      format.html { render component: 'CharacterApp', character_id: @character.id, user_id: @user.id }
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
