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

class Media::Favorite < ApplicationRecord
  include NamespacedModel

  belongs_to :media, class_name: Image, counter_cache: :favorites_count, inverse_of: :favorites
  belongs_to :user

  validates_presence_of :media
  validates_presence_of :user
  validate :unique_favorite

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
end
