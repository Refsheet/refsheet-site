class SwatchesController < ApplicationController
  before_action :get_user, except: [:update, :destroy]
  before_action :get_character, except: [:update, :destroy]
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
      render json: @swatch.character.swatches.rank(:row_order), each_serializer: SwatchSerializer
    else
      render json: { errors: @swatch.errors }, status: :bad_request
    end
  end

  def destroy
    @swatch.destroy
    render json: @swatch.character.swatches.rank(:row_order), each_serializer: SwatchSerializer
  end

  private

  def get_user
    @user = User.lookup(params[:user_id])
  end

  def get_character
    @character = @user.characters.find_by!(slug: params[:character_id])
  end

  def get_swatch
    if @character
      @swatch = @character.swatches.find_by!(guid: params[:id])
    else
      @swatch = Swatch.find_by!(guid: params[:id])
    end
  end

  def swatch_params
    p = params.require(:swatch).permit(:color, :name, :notes, :row_order_position)
    p[:character] = @character if @character
    p
  end
end
