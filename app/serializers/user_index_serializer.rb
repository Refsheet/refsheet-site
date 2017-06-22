class UserIndexSerializer < ActiveModel::Serializer
  attributes :name,
             :username,
             :avatar_url,
             :is_admin,
             :is_patron,
             :settings

  def is_admin
    object.role? :admin
  end

  def is_patron
    object.pledges.active.any?
  end
end
