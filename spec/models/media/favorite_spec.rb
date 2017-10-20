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

require 'rails_helper'

describe Media::Favorite, type: :model do
  it_is_expected_to(
      belong_to: [
          :media,
          :user
      ],
      validate_presence_of: [
          :media,
          :user
      ]
  )

  it 'rejects doubles' do
    c1 = create :media_favorite
    c2 = build :media_favorite, media: c1.media, user: c1.user
    expect(c2).to have(1).errors_on :media
  end
end
