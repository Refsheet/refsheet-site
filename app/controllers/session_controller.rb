class SessionController < ApplicationController
  def new
    if params.include?(:email) && params.include?(:auth)
      @user = User.lookup params[:email]

      if @user&.auth_code? params[:auth]
        sign_in @user

        if params[:auth] =~ /\A\d{6}\z/
          redirect_to user_profile_path(@user, anchor: 'user-settings-modal'), flash: { notice: 'You have been signed in, don\'t forget to change your password.' }
        else
          @user.confirm!
          redirect_to user_profile_path(@user), flash: { notice: 'Email address confirmed!' }
        end

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
      sign_in @user, remember: bool(params[:remember])
      render json: session_hash
    else
      render json: { error: 'Invalid username or password.' }, status: :unauthorized
    end
  end

  def update
    # Legacy
    if params.include? :nsfw_ok
      bool(params[:nsfw_ok]) ? nsfw_on! : nsfw_off!
    end

    # V2 Javascript
    if params.include? :nsfwOk
      bool(params[:nsfwOk]) ? nsfw_on! : nsfw_off!
    end

    render json: session_hash
  end

  def destroy
    sign_out
    head :ok
  end

  private

  def user_params
    params[:remember] = params[:user].delete(:remember) unless params.include? :remember
    params.require(:user).permit(:username, :password, :auth)
  end
end
