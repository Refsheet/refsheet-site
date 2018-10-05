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

FactoryBot.define do
  factory :media_favorite, class: 'Media::Favorite' do
    association :media, factory: :image
    user
  end
end
