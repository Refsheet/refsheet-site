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

class Notifications::ImageComment < Notification
  delegate :media, :comment, to: :actionable, allow_nil: true

  def title
    "#{sender&.name || "(deleted account)"} commented on #{media&.title || "<Deleted Image>"}"
  end

  def message
    return nil if actionable.nil?
    "\"#{comment.truncate(120).chomp}\""
  end

  def href
    return nil if actionable.nil?
    media && image_url(media)
  end

  def link
    return nil if actionable.nil?
    media && image_path(media)
  end

  protected

  def permission_key
    :image_comment
  end
end
