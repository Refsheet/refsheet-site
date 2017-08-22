require 'rails_helper'

describe Forum, type: :model do
  it_is_expected_to(
      have_many: [
          :threads,
          :posts
      ],
      validate_presence_of: [
          :name,
          :slug
      ]
  )
end
