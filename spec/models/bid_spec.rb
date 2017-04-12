# == Schema Information
#
# Table name: bids
#
#  id              :integer          not null, primary key
#  auction_id      :integer
#  user_id         :integer
#  invitation_id   :integer
#  amount_cents    :integer          default("0"), not null
#  amount_currency :string           default("USD"), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'rails_helper'

describe Bid, type: :model do
  it_is_expected_to(
    belong_to: [
      :auction,
      :user,
      :invitation
    ],
    validate_numericality_of: :amount_cents
  )
end
