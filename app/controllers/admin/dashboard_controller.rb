class Admin::DashboardController < AdminController
  def show
    @users = User.all
    @characters = Character.all
  end
end