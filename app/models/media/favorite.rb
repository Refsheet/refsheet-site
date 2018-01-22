# == Schema Information
#
# Table name: media_favorites
#
#  id         :integer          not null, primary key
#  media_id   :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_media_favorites_on_media_id  (media_id)
#  index_media_favorites_on_user_id   (user_id)
#

class Media::Favorite < ApplicationRecord
  include NamespacedModel
  include Rails.application.routes.url_helpers

  belongs_to :media, class_name: Image, counter_cache: :favorites_count, inverse_of: :favorites
  belongs_to :user

  validates_presence_of :media
  validates_presence_of :user
  validate :unique_favorite, on: :create

  after_create :notify_user

  def guid
    Digest::MD5.hexdigest media_id.to_s + user_id.to_s
  end

  private

  def unique_favorite
    if Media::Favorite.exists? user: self.user, media: self.media
      self.errors.add :media, 'has already been liked'
      false
    end
    true
  end

  def notify_user
    media.user.notify! "New image favorite!",
                       "#{user.name} likes #{media.title}!",
                       href: image_url(media),
                       tag: 'rs-fav-' + guid
  end
end
