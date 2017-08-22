require 'rails_helper'

describe Forum::Thread, type: :model do
  it_is_expected_to(
      belong_to: [
          :forum,
          :user,
          :character
      ],
      have_many: [
          :posts,
          :karmas
      ],
      validate_presence_of: [
          :title,
          :content,
          :user,
          :slug,
          :shortcode
      ]
  )
end
