class Admin::UsersController < AdminController
  before_action :get_user, except: [:index, :new, :create]

  def index
    @users = filter_scope User.all
  end

  def new
    @user = User.new
  end

  def show; end
  def edit; end

  def create
    @user = User.create(user_params)
    respond_with :admin, @user
  end

  def update
    if @user.update_attributes(user_params)
      Changelog.create changelog_params
    end
    
    respond_with :admin, @user
  end

  private

  def get_user
    @user = User.lookup! params[:id]
  end

  def user_params
    params.require(:user).permit!
  end

  def changelog_params
    {
        user: current_user,
        reason: params[:reason],
        change_data: @user.previous_changes,
        changed_user: @user
    }
  end
end
