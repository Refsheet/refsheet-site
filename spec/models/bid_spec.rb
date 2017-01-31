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

RSpec.describe Bid, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
