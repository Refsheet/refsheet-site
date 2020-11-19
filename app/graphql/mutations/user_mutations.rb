class Mutations::UserMutations < Mutations::ApplicationMutation
  before_action :get_current_user, only: [:set_avatar_blob]

  action :index do
    type types[Types::UserType]

    argument :with_deleted, type: types.Boolean
    argument :order, type: types.String
    argument :ascending, type: types.Boolean
    argument :page, type: types.Int
    argument :query, type: types.String
  end

  def index
    authorize User, :index?
    scope = User.all

    if params[:with_deleted]
      authorize User, :show_deleted?
      scope = scope.with_deleted
    end

    if params[:query]
      scope = scope.search_for(params[:query])
    end

    scope = scope.order(created_at: :desc)

    scope = scope.page(params[:page] || 1)
    scope
  end

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

  action :set_avatar_blob do
    type Types::UserType

    argument :id, types.ID
    argument :blob, types.String
  end

  def set_avatar_blob
    authorize @user, :update?

    if params[:blob].blank?
      @user.as_avatar.detach
    else
      @user.as_avatar.attach(params[:blob])
    end

    @user.save!
    @user
  end

  private

  def get_current_user
    if params[:id].present?
      @user = User.find_by(guid: params[:id])
    else
      @user = current_user
    end
  end
end
