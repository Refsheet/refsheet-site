# == Schema Information
#
# Table name: auctions
#
#  id                        :integer          not null, primary key
#  item_id                   :integer
#  slot_id                   :integer
#  starting_bid_cents        :integer          default("0"), not null
#  starting_bid_currency     :string           default("USD"), not null
#  minimum_increase_cents    :integer          default("0"), not null
#  minimum_increase_currency :string           default("USD"), not null
#  starts_at                 :datetime
#  ends_at                   :datetime
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#

FactoryBot.define do
  factory :auction do
    item_id { 1 }
    slot_id { 1 }
    starting_bid_cents { 1 }
    minimum_increase_cents { 1 }
    starts_at { "2017-01-30 17:36:10" }
    ends_at { "2017-01-30 17:36:10" }
  end
end
