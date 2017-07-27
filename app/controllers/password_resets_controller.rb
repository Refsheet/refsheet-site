class PasswordResetsController < ApplicationController
  def create
    if (@user = User.lookup params[:user][:email])
      auth_code = @user.generate_auth_code! true
      UserMailer.password_reset(@user.id, auth_code).deliver_now
      render json: { user: { email: @user.email } }
    else
      render json: { errors: { email: ['User not found.'] } }, status: :not_found
    end
  end

  def update
    unless (@user = User.lookup params[:reset][:email])
      return render json: { error: 'User not found.' }, status: :not_found
    end

    if @user.auth_code? params[:reset][:token]
      @user.update! auth_code_digest: nil
      sign_in @user
      render json: session_hash
    else
      render json: { errors: { token: ['Invalid token.'] } }, status: :bad_request
    end
  end
end
