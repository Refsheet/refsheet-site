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

FactoryBot.define do
  factory :bid do
    auction_id { 1 }
    user_id { 1 }
    invitation_id { 1 }
    amount_cents { 1 }
  end
end
