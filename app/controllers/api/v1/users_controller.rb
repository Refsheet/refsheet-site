# See: http://jsonapi-rb.org/guides/getting_started/rails.html
# See: https://github.com/varvet/pundit
class Api::V1::UsersController < ApiController
  before_action :get_user, only: [:show, :update]

  def show
    authorize @user

    render json: @user, serializer: Api::V1::UserSerializer
  end

  def lookup
    @user = User.find_by!('LOWER(users.username) = ?', params[:username]&.downcase)
    authorize @user, :show?

    render json: Panko::Response.new(
        success: true,
        user: Api::V1::UserSerializer.new.serialize(@user)
    )
  end

  def update
    authorize @user

    if @user.update_attributes(user_params)
      render jsonapi: @user
    else
      render jsonapi_errors: @user
    end
  end

  private

  def get_user
    @user = User.find_by!(guid: params[:id])
  end

  def user_params
    params.require(:data)
        .require(:attributes)
        .permit(:name, :username, :profile, :email)
  end
end