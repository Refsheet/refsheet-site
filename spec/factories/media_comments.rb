# == Schema Information
#
# Table name: media_comments
#
#  id         :integer          not null, primary key
#  media_id   :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :media_comment, class: 'Media::Comment' do
    association :media, factory: :image
    user
    comment { Faker::Lorem.paragraph }
  end
end

