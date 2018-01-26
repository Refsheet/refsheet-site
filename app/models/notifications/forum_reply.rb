class Notifications::ForumReply < Notification
  delegate :forum, :thread, to: :actionable

  def title
    "#{sender.name} replied to #{actionable.thread.topic}"
  end

  def message
    "\"#{actionable.content.to_text.truncate(120).chomp}\""
  end

  def href
    forum_thread_url forum, thread.slug, anchor: actionable.guid
  end

  protected

  def permission_key
    :forum_reply
  end
end
