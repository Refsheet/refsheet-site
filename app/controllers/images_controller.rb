class ImagesController < ApplicationController
  before_action :get_user
  before_action :get_character
  before_action :get_image, only: [:update, :destroy]

  respond_to :json

  def index
    render json: @character.images.rank(:row_order), each_serializer: ImageSerializer
  end

  def create
    @image = Image.create image_params

    if @image.save
      render json: @character.images.rank(:row_order), each_serializer: ImageSerializer
    else
      render json: { errors: @image.errors }, status: :bad_request
    end
  end

  def update
    if @image.update_attributes image_params
      render json: @character.images.rank(:row_order), each_serializer: ImageSerializer
    else
      render json: { errors: @image.errors }, status: :bad_request
    end
  end

  def destroy
    @image.destroy
    render json: @character.images.rank(:row_order), each_serializer: ImageSerializer
  end

  private

  def get_user
    @user = User.find_by!(username: params[:user_id])
  end

  def get_character
    @character = @user.characters.find_by!(url: params[:character_id])
  end

  def get_image
    @image = @character.images.find_by!(guid: params[:id])
  end

  def image_params
    params.require(:image).permit(:color, :name, :notes, :row_order_position).merge(character: @character)
  end
end
