require 'rails_helper'

describe Media::ArtistCredit, type: :model do
  it_is_expected_to belong_to: [:media,
                                :artist,
                                :validated_by_user,
                                :tagged_by_user]
end
