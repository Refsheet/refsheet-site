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

require 'rails_helper'

RSpec.describe Patreon::Pledge, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
