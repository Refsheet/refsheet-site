class Mutations::SessionMutations < Mutations::ApplicationMutation
  action :delete do
    type Types::SessionType
  end

  def delete
    sign_out
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
      return session_hash
    end

    not_allowed! "Invalid username or password."
  end
end
