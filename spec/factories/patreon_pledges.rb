# == Schema Information
#
# Table name: patreon_pledges
#
#  id                :integer          not null, primary key
#  patreon_id        :string
#  amount_cents      :integer
#  declined_since    :datetime
#  patron_pays_fees  :boolean
#  pledge_cap_cents  :integer
#  patreon_reward_id :integer
#  patreon_patron_id :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_patreon_pledges_on_patreon_id         (patreon_id)
#  index_patreon_pledges_on_patreon_patron_id  (patreon_patron_id)
#

FactoryBot.define do
  factory :patreon_pledge, class: 'Patreon::Pledge' do
    patreon_id { "MyString" }
    amount_cents { 1 }
    declined_since { "2017-01-18 17:14:27" }
    patron_pays_fees { false }
    pledge_cap_cents { 1 }
  end
end
