class UsersController < ApplicationController
  def create
    @user = User.new user_params

    if @user.save
      sign_in @user
      render json: @user, serializer: UserSerializer
    else
      render json: { errors: @user.errors }, status: :bad_request
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end
end
