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
