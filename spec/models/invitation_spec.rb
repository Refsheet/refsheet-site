# == Schema Information
#
# Table name: invitations
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  email      :string
#  seen_at    :datetime
#  claimed_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

describe Invitation, type: :model do
  it_is_expected_to(
    belong_to: :user,
    have_many: :transfers
  )
end
