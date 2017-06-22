class SessionController < ApplicationController
  def new
    if params.include?(:email) && params.include?(:auth)
      @user = User.lookup params[:email]

      if @user&.auth_code? params[:auth]
        @user.confirm!
        sign_in @user

        redirect_to user_profile_path(@user), flash: { notice: 'Email address confirmed!' }
        return
      else
        flash.now[:error] = 'Invalid authentication code!'
      end
    end

    render 'application/show'
  end

  def show
    render json: session_hash
  end

  def create
    @user = User.lookup user_params[:username]

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
    params.require(:user).permit(:username, :password, :auth)
  end
end
