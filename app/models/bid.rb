# == Schema Information
#
# Table name: bids
#
#  id              :integer          not null, primary key
#  auction_id      :integer
#  user_id         :integer
#  invitation_id   :integer
#  amount_cents    :integer          default(0), not null
#  amount_currency :string           default("USD"), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_bids_on_auction_id  (auction_id)
#  index_bids_on_user_id     (user_id)
#

class Bid < ApplicationRecord
  belongs_to :auction
  belongs_to :user
  belongs_to :invitation

  monetize :amount_cents
end
