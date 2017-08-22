require 'rails_helper'

describe Forum::Post, type: :model do
  it_is_expected_to(
      belong_to: [
          :thread,
          :forum,
          :user,
          :character,
          :parent_post
      ],
      have_many: [
          :replies,
          :karmas
      ],
      validate_presence_of: [
          :thread,
          :user,
          :content,
          :guid
      ]
  )
end
