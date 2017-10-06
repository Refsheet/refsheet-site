# == Schema Information
#
# Table name: activities
#
#  id              :integer          not null, primary key
#  guid            :string
#  user_id         :integer
#  character_id    :integer
#  activity_type   :string
#  activity_id     :integer
#  activity_method :string
#  activity_field  :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'rails_helper'

describe Activity, type: :model do
  it_is_expected_to(
      belong_to: [
          :user,
          :character,
          :activity,
          :activity_comment,
          :activity_discussion,
          :activity_character,
          :activity_image
      ]
  )

  it 'eager loads' do
    chr = create :character
    img = create :image, character: chr
    dsc = create :forum_discussion, user: chr.user
    cmt = create :media_comment, media: img, user: chr.user

    expect(Activity.eager_loaded).to have_at_least(4).items

    activities = Activity.eager_loaded.collect(&:activity)
    expect(activities).to include chr
    expect(activities).to include img
    expect(activities).to include dsc
    expect(activities).to include cmt
  end
end
