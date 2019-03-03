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

class Notifications::ForumTag < Notification
  delegate :forum, :thread, to: :actionable, allow_nil: true

  def title
    "#{sender.name} mentioned you in a forum post"
  end

  def message
    "\"#{actionable.content.to_text.truncate(120).chomp}\""
  end

  def href
    forum_thread_url forum, thread.slug, anchor: actionable.guid
  end

  def link
    forum_thread_path forum, thread.slug, anchor: actionable.guid
  end

  protected

  def permission_key
    :forum_tag
  end
end
