class PrivateUserSerializer < ActiveModel::Serializer
  attributes :name,
             :username,
             :email,
             :avatar_url,
             :is_admin,
             :is_patron,
             :is_supporter,
             :is_moderator,
             :settings,
             :link,
             :password,
             :password_confirmation,
             :email_confirmed_at,
             :unconfirmed_email,
             :path

  def password
  end

  def password_confirmation
  end

  def is_admin
    object.admin?
  end

  def is_patron
    object.patron?
  end

  def link
    "/#{object.username}"
  end

  def path
    "/users/#{object.username}"
  end

  def settings
    object.get_settings
  end
end
