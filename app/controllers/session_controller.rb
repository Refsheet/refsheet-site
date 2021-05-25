class SessionController < ApplicationController
  def new
    render 'application/show'
  end

  def activate
    if params.include?(:email) && params.include?(:auth)
      @user = User.lookup params[:email]
      if @user&.check_email_confirmation? params[:auth]
        sign_in @user, remember: false unless signed_in?
        @user.confirm!
        redirect_to user_profile_path(@user), flash: { notice: 'Email address confirmed!' }
        return
      end
    end

    flash[:error] = 'Confirmation link invalid or expired.'
    redirect_to action: 'new'
  end

  def confirm_email_change
    if params.include?(:email) && params.include?(:auth)
      @user = User.lookup params[:email]
      if @user&.check_email_change? params[:auth]
        sign_in @user, remember: false unless signed_in?
        @user.confirm!
        redirect_to user_profile_path(@user), flash: { notice: 'Email address changed!' }
        return
      end
    end

    flash[:error] = 'Confirmation link invalid or expired.'
    redirect_to action: 'new'
  end

  def recover
    if params.include?(:email) && params.include?(:auth)
      @user = User.lookup params[:email]
      if @user&.check_account_recovery? params[:auth]
        sign_in @user, remember: false
        redirect_to account_settings_path, flash: { notice: 'You have been signed in, don\'t forget to change your password.' }
        return
      end
    end

    flash[:error] = 'Recovery link invalid or expired.'
    redirect_to action: 'new'
  end

  def show
    render json: session_hash
  end

  def create
    @user = User.lookup user_params[:username]

    if @user&.authenticate(user_params[:password])
      if @user&.confirmed?
        sign_in @user, remember: bool(params[:remember])
        render json: session_hash
      else
        render json: { error: 'Please check your email for account activation link.' }, status: :unauthorized
      end
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
