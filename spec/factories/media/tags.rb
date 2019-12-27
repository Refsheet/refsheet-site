# == Schema Information
#
# Table name: media_tags
#
#  id           :integer          not null, primary key
#  media_id     :integer
#  character_id :integer
#  position_x   :integer
#  position_y   :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_media_tags_on_character_id  (character_id)
#  index_media_tags_on_media_id      (media_id)
#

FactoryBot.define do
  factory :media_tag, class: 'Media::Tag' do
    media { nil }
    character { nil }
    position_x { 1 }
    position_y { 1 }
  end
end
