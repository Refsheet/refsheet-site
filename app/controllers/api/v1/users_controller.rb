# See: http://jsonapi-rb.org/guides/getting_started/rails.html
# See: https://github.com/varvet/pundit
class Api::V1::UsersController < ApiController
  before_action :get_user, only: [:show, :update]

  def show
    authorize @user
    respond_with @user
  end

  def lookup
    @user = User.find_by!('LOWER(users.username) = ?', params[:username]&.downcase)
    authorize @user, :show?
    respond_with @user
  end

  def update
    authorize @user
    @user.update_attributes(user_params)
    respond_with @user
  end

  private

  def get_user
    @user = User.find_by!(guid: params[:id])
  end

  def user_params
    params.require(:user)
        .permit(:name, :username, :profile, :email)
  end
end