class SwatchesController < ApplicationController
  before_action :get_user
  before_action :get_character
  before_action :get_swatch, only: [:update, :destroy]

  def index
    @swatches = @character.swatches #order
    render json: @swatches
  end

  def create; end
  def update; end
  def destroy; end

  private

  def get_user
    @user = User.find_by!(username: params[:user_id])
  end

  def get_character
    @character = @user.characters.find_by!(url: params[:character_id])
  end

  def get_swatch
    @swatch = @character.swatches.find_by!(guid: params[:id])
  end
end
