require 'rails_helper'

describe Media::Favorite, type: :model do
  it_is_expected_to(
      belong_to: [
          :media,
          :user
      ],
      validate_presence_of: [
          :media,
          :user
      ]
  )
end
