class Media::ArtistCredit < ApplicationRecord
  belongs_to :media, class_name: 'Image', inverse_of: :artist_credits
  belongs_to :artist
  belongs_to :validated_by_user, class_name: 'User'
  belongs_to :tagged_by_user, class_name: 'User'
end
