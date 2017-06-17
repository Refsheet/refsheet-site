class SessionController < ApplicationController
  def show
    render json: session_hash
  end

  def create
    if user_params[:username] =~ /@/
      @user = User.find_by('LOWER(users.email) = ?', user_params[:username].downcase)
    else
      @user = User.find_by('LOWER(users.username) = ?', user_params[:username].downcase)
    end

    if @user&.authenticate(user_params[:password])
      sign_in @user
      render json: session_hash
    else
      render json: { error: 'Invalid username or password.' }, status: :unauthorized
    end
  end

  def update
    if params.include? :nsfw_ok
      params[:nsfw_ok] == 'true' ? nsfw_on! : nsfw_off!
    end

    render json: session_hash
  end

  def destroy
    sign_out
    head :ok
  end

  private

  def user_params
    params.require(:user).permit(:username, :password)
  end
end
