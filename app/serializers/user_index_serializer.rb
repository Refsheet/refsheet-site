class UserIndexSerializer < ActiveModel::Serializer
  attributes :name,
             :username,
             :avatar_url,
             :is_admin,
             :is_patron,
             :settings,
             :link,
             :path

  def is_admin
    object.role? :admin
  end

  def is_patron
    object.pledges.active.any?
  end

  def link
    "/#{object.username}"
  end

  def path
    "/users/#{object.username}"
  end
end
