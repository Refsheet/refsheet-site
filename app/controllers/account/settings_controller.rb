class Account::SettingsController < AccountController
  def show
    respond_with current_user, serializer: PrivateUserSerializer
  end

  def update

  end
end
