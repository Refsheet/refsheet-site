class Notifications::ImageFavorite < Notification
  delegate :media, to: :actionable

  def title
    "New image favorite!"
  end

  def message
    "#{sender.name} likes #{media.title}!"
  end

  def href
    image_url(media)
  end

  protected

  def permission_key
    :image_favorite
  end
end
