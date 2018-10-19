class UserIndexSerializer < ActiveModel::Serializer
  attributes :name,
             :username,
             :avatar_url,
             :is_admin,
             :is_patron,
             :link,
             :path

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
end
