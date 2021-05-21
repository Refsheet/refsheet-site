class UsersController < ApplicationController
  before_action :get_user, only: [:show, :update]
  respond_to :json

  def index
    not_allowed!
  end

  def shortcode
    redirect_to user_profile_url(params[:id], hostname: 'refsheet.net')
  end

  def show
    @user = User.includes(:characters => [:profile_image, :featured_image, :color_scheme, :character_groups], :character_groups => [:user]).find(@user.id)
    authorize @user

    respond_to do |format|
      format.html do
        set_meta_tags(
            twitter: {
                card: 'photo',
                image: {
                    _: @user.avatar_url(:medium)
                }
            },
            og: {
                image: @user.avatar_url(:medium)
            },
            title: @user.name,
            description: @user.profile.presence || 'This user is a mystery!',
            image_src: @user.avatar_url(:medium)
        )

        eager_load user: UserSerializer.new(@user, scope: view_context).as_json
        render 'application/show'
      end
      format.json { render json: @user, serializer: UserSerializer, include: %w(characters.color_scheme character_groups) }
    end
  end

  def create
    @user = User.new user_params
    authorize @user

    captcha_data = params[:user][:captchaData]

    if verify_recaptcha(model: @user, response: captcha_data) && @user.save
      sign_in @user
      render json: @user, serializer: UserIndexSerializer
    else
      Rails.logger.debug @user.errors.full_messages.inspect
      render json: { errors: @user.errors }, status: :bad_request
    end
  end

  def update
    authorize @user

    if @user.update user_params
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
