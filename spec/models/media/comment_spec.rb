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
