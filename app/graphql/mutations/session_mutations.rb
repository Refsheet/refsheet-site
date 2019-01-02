class Mutations::SessionMutations < Mutations::ApplicationMutation
  action :show do
    type Types::SessionType
  end

  def show
    session_hash
  end

  action :destroy do
    type Types::SessionType
  end

  def destroy
    sign_out
    Rails.logger.info session_hash.inspect
    session_hash
  end

  action :create do
    type Types::SessionType

    argument :username, !types.String
    argument :password, !types.String
    argument :remember, types.Boolean
  end

  def create
    @user = User.lookup params[:username]

    if @user&.authenticate(params[:password])
      sign_in @user, remember: bool(params[:remember])
      Rails.logger.info session_hash.inspect
      return session_hash
    end

    not_allowed! "Invalid username or password."
  end
end
