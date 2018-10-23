class PrivateUserSerializer < ActiveModel::Serializer
  attributes :name,
             :username,
             :email,
             :avatar_url,
             :is_admin,
             :is_patron,
             :settings,
             :link,
             :password,
             :password_confirmation,
             :path

  has_one :patron
  has_many :pledges

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
    {
        view: object.settings(:view),
        notifications: object.settings(:notifications),
        emails: object.settings(:emails)
    }
  end
end
