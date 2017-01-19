# == Schema Information
#
# Table name: patreon_rewards
#
#  id                :integer          not null, primary key
#  patreon_id        :string
#  amount_cents      :integer
#  description       :text
#  image_url         :string
#  requires_shipping :boolean
#  title             :string
#  url               :string
#  grants_badge      :boolean
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

require 'rails_helper'

RSpec.describe Patreon::Reward, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
