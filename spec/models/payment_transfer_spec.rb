# == Schema Information
#
# Table name: payment_transfers
#
#  id              :integer          not null, primary key
#  seller_id       :integer
#  payment_id      :integer
#  order_id        :integer
#  processor_id    :string
#  type            :string
#  amount_cents    :integer          default(0), not null
#  amount_currency :string           default("USD"), not null
#  status          :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_payment_transfers_on_order_id      (order_id)
#  index_payment_transfers_on_payment_id    (payment_id)
#  index_payment_transfers_on_processor_id  (processor_id)
#  index_payment_transfers_on_seller_id     (seller_id)
#  index_payment_transfers_on_type          (type)
#

require 'rails_helper'

RSpec.describe PaymentTransfer, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
