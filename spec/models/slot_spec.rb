# == Schema Information
#
# Table name: slots
#
#  id                 :integer          not null, primary key
#  item_id            :integer
#  extends_slot_id    :integer
#  title              :string
#  description        :text
#  color              :string
#  amount_cents       :integer          default(0), not null
#  amount_currency    :string           default("USD"), not null
#  requires_character :boolean
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

require 'rails_helper'

describe Slot, type: :model do
  it_is_expected_to(
    belong_to: :item,
    validate_numericality_of: :amount_cents
  )
end
