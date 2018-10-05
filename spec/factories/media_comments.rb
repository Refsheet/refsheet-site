# == Schema Information
#
# Table name: media_comments
#
#  id                  :integer          not null, primary key
#  media_id            :integer
#  user_id             :integer
#  reply_to_comment_id :integer
#  comment             :text
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  guid                :string
#
# Indexes
#
#  index_media_comments_on_guid                 (guid)
#  index_media_comments_on_media_id             (media_id)
#  index_media_comments_on_reply_to_comment_id  (reply_to_comment_id)
#  index_media_comments_on_user_id              (user_id)
#

FactoryBot.define do
  factory :media_comment, class: 'Media::Comment' do
    association :media, factory: :image
    user
    comment { Faker::Lorem.paragraph }
  end
end

