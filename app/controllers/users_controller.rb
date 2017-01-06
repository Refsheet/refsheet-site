class UsersController < ApplicationController
  before_action :get_user, only: [:show, :update]

  def show
    respond_to do |format|
      format.html { render 'application/show' }
      format.json { render json: @user, serializer: UserSerializer }
    end
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
    if @user.update_attributes user_params
      render json: @user, serializer: UserSerializer
    else
      render json: { errors: @user.errors }, status: :bad_request
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :profile)
  end

  def get_user
    @user = User.lookup!(params[:id])
  end
end
