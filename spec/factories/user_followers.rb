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

FactoryGirl.define do
  factory :user_follower, class: 'User::Follower' do
    followee_id 1
    follower_id 1
  end
end
