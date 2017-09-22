class ImagesController < ApplicationController
  before_action :get_user, except: [:show, :full, :update, :destroy]
  before_action :get_character, except: [:show, :full, :update, :destroy]
  before_action :get_image, only: [:show, :full, :update, :destroy]

  respond_to :json

  def index
    render json: image_scope.includes(:favorites, :character, :comments), each_serializer: ImageSerializer
  end

  def show
    set_meta_tags(
        twitter: {
            card: 'photo',
            image: {
                _: @image.image.url(:medium)
            }
        },
        og: {
            image: @image.image.url(:medium)
        },
        title: @image.title,
        description: @image.caption || 'This image has no caption!',
        image_src: @image.image.url(:medium)
    )

    respond_to do |format|
      format.html do
        eager_load image: ImageSerializer.new(@image, scope: self).as_json
        render 'application/show'
      end

      format.json { render json: @image, serializer: ImageSerializer, include: 'character,comments,comments.user,favorites' }
    end
  end

  def full
    head :unauthorized and return unless @image.managed_by? current_user
    redirect_to @image.image.expiring_url(30, :original)
  end

  def create
    head :unauthorized and return unless @character.managed_by? current_user

    @image = Image.new image_params.merge(character: @character)

    if @image.save
      render json: @image, serializer: ImageSerializer
    else
      render json: { errors: @image.errors }, status: :bad_request
    end
  end

  def update
    head :unauthorized and return unless @image.managed_by? current_user

    if params[:image][:swap_target_image_id]
      target = Image.find_by!(guid: params[:image][:swap_target_image_id])
      @image.row_order = target.row_order - 1
      @image.save

      @character = @image.character
      render json: image_scope, each_serializer: ImageSerializer
    elsif @image.update_attributes image_params
      if image_params.include? :gravity
        @image.regenerate_thumbnail!
      end

      render json: @image, serializer: ImageSerializer
    else
      render json: { errors: @image.errors }, status: :bad_request
    end
  end

  def destroy
    head :unauthorized and return unless @image.managed_by? current_user

    @image.delete
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
        :background_color
    )
  end

  def image_scope
    scope = @character.images.rank(:row_order)

    unless @character.managed_by? current_user
      scope = scope.sfw unless nsfw_on?
      scope = scope.visible
    end

    scope
  end
end
