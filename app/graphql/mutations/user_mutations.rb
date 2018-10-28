class Mutations::UserMutations < Mutations::ApplicationMutation
  action :delete do
    type Types::UserType

    argument :username, type: !types.String
    argument :password, type: !types.String
  end

  def delete
    @user = current_user

    if @user.username == params[:username] && @user.authenticate(params[:password])
      @user.destroy
      sign_out
      return @user
    end

    not_allowed! "Invalid username or password."
  end
end
