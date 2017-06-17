class UserIndexSerializer < ActiveModel::Serializer
  attributes :name,
             :username,
             :avatar_url,
             :settings
end
