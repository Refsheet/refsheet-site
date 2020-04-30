class Mutations::UserMutations < Mutations::ApplicationMutation
  action :autocomplete do
    type types[Types::UserType]

    argument :username, type: types.String
  end

  def autocomplete
    q = params[:username].downcase + '%'
    User.where('LOWER(users.username) LIKE ? OR LOWER(users.name) LIKE ?', q, q).limit(10).order(:username)
  end

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
