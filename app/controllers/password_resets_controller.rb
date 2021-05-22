class PasswordResetsController < ApplicationController
  def create
    if (@user = User.lookup params[:user][:email])
      @user&.start_account_recovery!
      render json: { user: { email: @user.email } }
    else
      render json: { errors: { email: ['User not found.'] } }, status: :not_found
    end
  end

  def update
    unless (@user = User.lookup params[:reset][:email])
      return render json: { error: 'User not found.' }, status: :not_found
    end

    if @user&.check_account_recovery? params[:reset][:token]
      sign_in @user
      render json: session_hash
    else
      render json: { errors: { token: ['Invalid token.'] } }, status: :bad_request
    end
  end
end
