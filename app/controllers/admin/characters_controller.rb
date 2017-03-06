class Admin::CharactersController < AdminController
  before_action :get_character, only: [:show, :update, :destroy]

  def show; end
  def edit; end

  def update
    respond_with :admin, @character.update_attributes(character_params)
  end

  private

  def get_character
    @character = Character.find(params[:id])
  end
end