class CharacterTransferSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id,
             :created_at,
             :status,
             :sender_username,
             :destination_username,
             :destination_email,
             :path,
             :character_path

  def id
    object.guid
  end

  def sender_username
    object.sender.username
  end

  def destination_username
    object.destination&.username
  end

  def destination_email
    object.invitation&.email
  end

  def path
    transfer_path(object.guid)
  end

  def character_path
    object.character&.path
  end
end
