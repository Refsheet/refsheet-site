class Media::Tag < ApplicationRecord
  include NamespacedModel

  belongs_to :media
  belongs_to :character
end
