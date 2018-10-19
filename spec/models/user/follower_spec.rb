# == Schema Information
#
# Table name: user_followers
#
#  id           :integer          not null, primary key
#  following_id :integer
#  follower_id  :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_user_followers_on_follower_id   (follower_id)
#  index_user_followers_on_following_id  (following_id)
#

require 'rails_helper'

describe User::Follower, type: :model do
  it_is_expected_to(
      belong_to: [
          :follower,
          :following
      ]
  )

  it 'offers suggestions' do
    users = create_list :user, 6
    users.first.follow! users.second
    users.first.follow! users.third
    users.second.follow! users.third
    users.second.follow! users.fourth
    users.second.follow! users.fifth
    users.third.follow! users.fifth

    suggested = users.first.followers.suggested

    expect(users.first).to be_following users.second
    expect(users.fourth).to be_followed_by users.second

    expect(suggested.first).to eq users.fifth
    expect(suggested.second).to eq users.fourth
    expect(suggested).to have(2).items
  end
end
