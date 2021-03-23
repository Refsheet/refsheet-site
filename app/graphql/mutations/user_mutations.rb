class Mutations::UserMutations < Mutations::ApplicationMutation
  before_action :get_current_user, only: [:set_avatar_blob, :ban_user]

  action :index, :paginated do
    type Types::UsersCollectionType

    argument :ids, type: types[types.ID]
    argument :with_deleted, type: types.Boolean
    argument :order, type: types.String
    argument :ascending, type: types.Boolean
    argument :page, type: types.Int
    argument :query, type: types.String
  end

  def index
    authorize User, :index?
    scope = User.all

    # Eager Loading
    scope = scope.with_attached_as_avatar

    if params[:ids] && params[:ids].length > 0
      Rails.logger.info("Searching in IDs: #{params[:ids].join(',')}")
      scope = scope.where(guid: params[:ids])
    end

    if params[:with_deleted]
      authorize User, :show_deleted?
      scope = scope.with_deleted
    end

    if params[:query]
      scope = scope.search_for(params[:query])
    end

    scope = scope.order(created_at: :desc)
    paginate(scope)
  end

  action :show do
    type Types::UserType

    argument :username, type: types.String
    argument :id, type: types.ID
  end

  def show
    if params[:id].present?
      @user = User.find_by!(guid: params[:id])
    else
      @user = User.lookup!(params[:username], false)
    end

    authorize @user, :show?
    @user
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
    @user = User.lookup!(params[:username], false)
    authorize @user

    # Deleting a user can be done by a moderator for support cases,
    # this will not generate a ban notice.
    if @user != current_user
      authorize @user, :moderate?
      @user.update_columns(deleted_at: Time.now)
      UserDestructionJob.perform_later(@user)
      @user
    else
      if @user.username == params[:username] && @user.authenticate(params[:password])
        @user.update_columns(deleted_at: Time.now)
        UserDestructionJob.perform_later(@user)
        sign_out
        return @user
      end

      not_allowed! "Invalid username or password."
    end
  end

  action :ban_user do
    type Types::UserType

    argument :id, type: !types.ID
    argument :moderation_ban, type: types.Boolean
    argument :moderation_reason, type: types.String
  end

  def ban_user
    authorize @user, :moderate?

    if @user === current_user
      raise "Do not ban yourself."
    end

    report = ModerationReport.create(
        user: @user,
        sender: current_user,
        moderatable: @user,
        violation_type: params[:moderation_ban] ? 'ban' : 'other',
        comment: params[:moderation_reason],
        skip_notice: true
    )

    report.ban!
    @user.update_columns(deleted_at: Time.now)
    UserDestructionJob.perform_later(@user)
    @user
  end

  action :block_user do
    type Types::UserType

    argument :username, type: !types.String
  end

  def block_user
    @user = current_user
    @target_user = User.lookup!(params[:username])
    @user.block! @target_user
    @target_user
  end

  action :unblock_user do
    type Types::UserType
    argument :username, type: !types.String
  end

  def unblock_user
    @user = current_user
    @target_user = User.lookup!(params[:username])
    @user.unblock! @target_user
    @target_user
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
