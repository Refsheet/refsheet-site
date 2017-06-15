require 'rails_helper'

describe CharacterGroup, type: :model do
  it_is_expected_to(
      belong_to: [
          :user
      ],
      have_and_belong_to_many: [
          :characters
      ],
      validate_presence_of: [
          :user,
          :name
      ]
  )
end
