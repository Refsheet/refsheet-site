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
