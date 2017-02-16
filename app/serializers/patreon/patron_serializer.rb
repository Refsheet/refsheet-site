class Patreon::PatronSerializer < ActiveModel::Serializer
  attributes :email,
             :full_name,
             :status,
             :thumb_url,
             :username

  def username
    object.user&.username
  end

end