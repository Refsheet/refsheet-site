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
#  amount_cents       :integer          default("0"), not null
#  amount_currency    :string           default("USD"), not null
#  requires_character :boolean
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

require 'rails_helper'

RSpec.describe Slot, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
