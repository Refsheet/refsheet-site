class Activity::UserSerializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :username,
             :avatar_url,
             :link,
             :path,
             :is_admin,
             :is_patron

  def id
    object.username
  end

  def link
    "/#{object.username}"
  end

  def path
    "/users/#{object.username}"
  end

  def is_admin
    object.admin?
  end

  def is_patron
    object.patron?
  end
end
