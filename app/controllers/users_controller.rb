class UsersController < ApplicationController
  before_action :get_user, only: [:show, :update]
  respond_to :json

  def index
    @users = User.all
    respond_with @users.reverse, each_serializer: UserIndexSerializer
  end

  def show
    set_meta_tags(
        twitter: {
            card: 'photo',
            image: {
                _: @user.avatar.url(:medium)
            }
        },
        og: {
            image: @user.avatar.url(:medium)
        },
        title: @user.name,
        description: @user.profile.presence || 'This user is a mystery!',
        image_src: @user.avatar.url(:medium)
    )

    @user = User.includes(:characters => [:profile_image, :featured_image, :user, :color_scheme], :character_groups => [:user]).find(@user.id)

    respond_to do |format|
      format.html do
        eager_load user: UserSerializer.new(@user).as_json
        render 'application/show'
      end
      format.json { render json: @user, serializer: UserSerializer, include: %w(characters.color_scheme character_groups) }
    end
  end

  def create
    @user = User.new user_params

    if @user.save
      sign_in @user
      render json: @user, serializer: UserSerializer
    else
      Rails.logger.debug @user.errors.full_messages.inspect
      render json: { errors: @user.errors }, status: :bad_request
    end
  end

  def update
    head :unauthorized and return unless @user == current_user

    if @user.update_attributes user_params
      render json: @user, serializer: UserSerializer
    else
      render json: { errors: @user.errors }, status: :bad_request
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :profile, :name, :avatar)
  end

  def get_user
    @user = User.lookup!(params[:id])
  end
end
