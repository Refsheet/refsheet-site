class SessionController < ApplicationController
  def show
    render json: session_hash
  end

  def create
    if params[:username] =~ /@/
      @user = User.find_by('LOWER(users.email) = ?', params[:username].downcase)
    else
      @user = User.find_by('LOWER(users.username) = ?', params[:username].downcase)
    end

    if @user&.authenticate(params[:password])
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

  def session_hash
    {
        nsfw_ok: session[:nsfw_ok],
        locale: session[:locale],
        time_zone: session[:time_zone],
        current_user: signed_in? ? UserSerializer.new(current_user).as_json : nil
    }
  end
end
