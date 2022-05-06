class ImagesController < ApplicationController
  before_action :get_user, except: [:show, :full, :update, :destroy, :refresh]
  before_action :get_character, except: [:show, :full, :update, :destroy, :refresh]
  before_action :get_image, only: [:show, :full, :update, :destroy, :refresh]

  def index
    render json: image_scope.includes(:favorites, :character, :comments),
           each_serializer: ImageSerializer
  end

  def show
    render json: @image, serializer: ImageSerializer, include: 'character,comments,comments.user,favorites'
  end

  def full
    head :unauthorized and return unless @image.managed_by? current_user
    authorize @image
    redirect_to @image.image.expiring_url(30, :original)
  end

  def create
    head :unauthorized and return unless @character.managed_by? current_user

    @image = Image.new image_params.merge(character: @character)
    authorize @image
    saved = nil

    PgLock.new(name: 'image_rank_lock').lock do
      saved = @image.save
    end

    if saved
      render json: @image, serializer: ImageSerializer
    else
      render json: { errors: @image.errors }, status: :bad_request
    end
  end

  def update
    head :unauthorized and return unless @image.managed_by? current_user
    authorize @image

    if params[:image][:swap_target_image_id]
      target = Image.find_by!(guid: params[:image][:swap_target_image_id])

      PgLock.new(name: 'image_rank_lock').lock do
        @image.row_order = target.row_order - 1
        @image.save
      end

      @character = @image.character
      render json: image_scope, each_serializer: ImageSerializer
    elsif @image.update image_params
      if image_params.include? :gravity or @image.watermark_changed?
        @image.regenerate_thumbnail!
      end

      render json: @image, serializer: ImageSerializer
    else
      render json: { errors: @image.errors }, status: :bad_request
    end
  end

  def destroy
    head :unauthorized and return unless @image.managed_by? current_user
    authorize @image

    @image.destroy
    render json: @image, serializer: ImageSerializer
  end

  def refresh
    head :unauthorized and return unless @image.managed_by? current_user

    @image.image.reprocess_without_delay!
    render json: @image, serializer: ImageSerializer
  end

  private

  def get_user
    @user = User.find_by!(username: params[:user_id])
  end

  def get_character
    @character = @user.characters.find_by!(slug: params[:character_id])
  end

  def get_image
    @image = Image.includes(:comments => [:media, :reply_to, :user]).find_by!(guid: params[:id])
  end

  def image_params
    params.require(:image).permit(
        :image,
        :artist_id,
        :caption,
        :source_url,
        :thumbnail,
        :gravity,
        :nsfw,
        :hidden,
        :title,
        :background_color,
        :watermark
    )
  end

  def image_scope
    scope = @character.images.rank(:row_order)

    unless @character.managed_by? current_user
      scope = scope.visible
    end

    scope
  end
end
