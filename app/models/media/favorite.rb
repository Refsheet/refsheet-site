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

  belongs_to :media, class_name: Image
  belongs_to :user

  validates_presence_of :media
  validates_presence_of :user
  validate :unique_favorite

  private

  def unique_favorite
    if Media::Favorite.exists? user: self.user, media: self.media
      self.errors.add :media, 'has already been liked'
      false
    end
    true
  end
end
