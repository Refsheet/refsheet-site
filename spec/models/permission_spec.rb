# == Schema Information
#
# Table name: permissions
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  role_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

describe Permission, type: :model do
  it_is_expected_to(
    belong_to: [
      :user,
      :role
    ],
    validate_presence_of: [
      :user,
      :role
    ]
  )
end
