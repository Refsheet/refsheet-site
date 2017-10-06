class Activity::UserSerializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :username,
             :avatar_url,
             :settings,
             :link,
             :path

  def id
    object.username
  end

  def link
    "/#{object.username}"
  end

  def path
    "/users/#{object.username}"
  end
end
