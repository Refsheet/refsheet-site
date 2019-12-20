class Media::Tag < ApplicationRecord
  belongs_to :media
  belongs_to :character
end
