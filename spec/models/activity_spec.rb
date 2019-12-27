# == Schema Information
#
# Table name: activities
#
#  id                   :integer          not null, primary key
#  guid                 :string
#  user_id              :integer
#  character_id         :integer
#  activity_type        :string
#  activity_id          :integer
#  activity_method      :string
#  activity_field       :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  comment              :text
#  reply_to_activity_id :integer
#
# Indexes
#
#  index_activities_on_activity_type         (activity_type)
#  index_activities_on_character_id          (character_id)
#  index_activities_on_reply_to_activity_id  (reply_to_activity_id)
#  index_activities_on_user_id               (user_id)
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

    expect(Activity.eager_loaded).to have_at_least(3).items

    activities = Activity.eager_loaded.collect(&:activity)
    expect(activities).to include chr
    expect(activities).to include dsc
    expect(activities).to include cmt
  end

  it 'dependent destroy' do
    chr = create :character
    expect(Activity.first.activity).to eq chr
    expect(Activity.count).to eq 1
    chr.destroy
    expect(Activity.count).to eq 0
  end

  it 'checks visible_to' do
    usr0 = create :user
    chr = create :character, hidden: true

    usr1 = chr.user
    expect(Activity.visible_to(usr1)).to have(1).items
    expect(Activity.visible_to(usr0)).to have(0).items
  end
end
