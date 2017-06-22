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

FactoryGirl.define do
  factory :media_favorite, class: 'Media::Favorite' do
    association :media, factory: :image
    user
  end
end
