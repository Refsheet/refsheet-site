class SessionController < ApplicationController
  def show
    render json: current_user
  end

  def create
    @user = User.find_by('LOWER(users.username) = ?', params[:username])

    if @user&.authenticate(params[:password])
      sign_in @user
      render json: @user, status: :created
    else
      render json: { error: 'Invalid username or password.' }, status: :unauthorized
    end
  end

  def destroy
    sign_out
    head :ok
  end
end
