class Media::Favorite < ApplicationRecord
  include NamespacedModel

  belongs_to :media, class_name: Image
  belongs_to :user

  validates_presence_of :media
  validates_presence_of :user
end
