class Notifications::ImageComment < Notification
  delegate :media, :comment, to: :actionable

  def title
    "#{sender.name} commented on #{media.title}"
  end

  def message
    "\"#{comment.truncate(120).chomp}\""
  end

  def href
    image_url(media)
  end

  protected

  def permission_key
    :image_comment
  end
end
