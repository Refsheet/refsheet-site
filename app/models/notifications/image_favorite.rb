# == Schema Information
#
# Table name: notifications
#
#  id                  :integer          not null, primary key
#  user_id             :integer
#  character_id        :integer
#  sender_user_id      :integer
#  sender_character_id :integer
#  type                :string
#  actionable_id       :integer
#  actionable_type     :string
#  read_at             :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  guid                :string
#
# Indexes
#
#  index_notifications_on_character_id  (character_id)
#  index_notifications_on_guid          (guid)
#  index_notifications_on_type          (type)
#  index_notifications_on_user_id       (user_id)
#

class Notifications::ImageFavorite < Notification
  delegate :media, to: :actionable, allow_nil: true

  def title
    "#{sender.name} likes #{media&.title || "<Deleted Image>"}!"
  end

  def href
    media && image_url(media)
  end

  def link
    media && image_path(media)
  end

  protected

  def permission_key
    :image_favorite
  end
end
