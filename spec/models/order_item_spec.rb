# == Schema Information
#
# Table name: order_items
#
#  id         :integer          not null, primary key
#  order_id   :integer
#  item_id    :integer
#  slot_id    :integer
#  auction_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

describe OrderItem, type: :model do
  it_is_expected_to(
    belong_to: [
      :order,
      :item,
      :slot,
      :auction
    ]
  )
end
