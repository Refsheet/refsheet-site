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
    @user.update_attributes(user_params)
    respond_with :admin, @user
  end

  private

  def get_user
    @user = User.lookup! params[:id]
  end

  def user_params
    params.require(:user).permit!
  end
end
