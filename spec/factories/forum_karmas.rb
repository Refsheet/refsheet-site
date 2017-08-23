# == Schema Information
#
# Table name: forum_karmas
#
#  id          :integer          not null, primary key
#  karmic_id   :integer
#  karmic_type :integer
#  user_id     :integer
#  discord     :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryGirl.define do
  factory :forum_karma, class: 'Forum::Karma' do
    karmic_id 1
    karmic_type 1
    user_id 1
    discord false
  end
end
