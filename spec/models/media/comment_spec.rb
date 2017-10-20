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

require 'rails_helper'

describe Media::Comment, type: :model do
  it_is_expected_to(
      belong_to: [
          :user,
          :media
      ],
      have_many: [
          :replies
      ],
      validate_presence_of: [
          :media,
          :user,
          :comment
      ]
  )
end
