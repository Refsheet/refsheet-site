class SessionController < ApplicationController
  def show
    render json: current_user
  end

  def create
    if params[:username] =~ /@/
      @user = User.find_by('LOWER(users.email) = ?', params[:username].downcase)
    else
      @user = User.find_by('LOWER(users.username) = ?', params[:username].downcase)
    end

    if @user&.authenticate(params[:password])
      sign_in @user
      render json: @user, serializer: UserSerializer
    else
      render json: { error: 'Invalid username or password.' }, status: :unauthorized
    end
  end

  def destroy
    sign_out
    head :ok
  end
end
