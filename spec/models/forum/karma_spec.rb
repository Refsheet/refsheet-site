require 'rails_helper'

describe Forum::Karma, type: :model do
  it_is_expected_to(
      belong_to: [
          :karmic,
          :user
      ],
      validate_presence_of: [
          :karmic,
          :user
      ]
  )
end
