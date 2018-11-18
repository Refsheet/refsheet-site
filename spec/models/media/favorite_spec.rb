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

  it 'notifies without kaboom' do
    expect_any_instance_of(User).to receive(:notify!).and_return(true)
    expect(create :media_favorite).to be_valid
  end

  it 'deletes notification' do
    f = create :media_favorite
    n = Notification.where(actionable_id: f.id)
    expect(n.count).to be > 0
    f.media.destroy
    expect(n.count).to eq 0
    expect { f.reload }.to raise_exception
  end
end
