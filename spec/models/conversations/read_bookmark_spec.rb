require 'rails_helper'

describe Conversations::ReadBookmark, type: :model do
  it_is_expected_to(
      belong_to: [
          :conversation, :message, :user
      ]
  )
end
