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
