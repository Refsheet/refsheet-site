class SwatchesController < ApplicationController
  before_action :get_user
  before_action :get_character
  before_action :get_swatch, only: [:update, :destroy]

  respond_to :json

  def index
    render json: @character.swatches.rank(:row_order), each_serializer: SwatchSerializer
  end

  def create
    @swatch = Swatch.create swatch_params

    if @swatch.save
      render json: @character.swatches.rank(:row_order), each_serializer: SwatchSerializer
    else
      render json: { errors: @swatch.errors }, status: :bad_request
    end
  end

  def update
    if @swatch.update_attributes swatch_params
      render json: @character.swatches.rank(:row_order), each_serializer: SwatchSerializer
    else
      render json: { errors: @swatch.errors }, status: :bad_request
    end
  end

  def destroy
    @swatch.destroy
    render json: @character.swatches.rank(:row_order), each_serializer: SwatchSerializer
  end

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

  def swatch_params
    params.require(:swatch).permit(:color, :name, :notes, :row_order_position).merge(character: @character)
  end
end
