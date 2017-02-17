class UsersController < ApplicationController
  before_action :get_user, only: [:show, :update]
  respond_to :json

  def index
    @users = User.all
    respond_with @users.reverse, each_serializer: UserIndexSerializer
  end

  def show
    render json: @user, serializer: UserSerializer
  end

  def create
    @user = User.new user_params

    if @user.save
      sign_in @user
      render json: @user, serializer: UserSerializer
    else
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
