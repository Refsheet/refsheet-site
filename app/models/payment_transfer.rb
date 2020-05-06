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

class PaymentTransfer < ApplicationRecord
  belongs_to :seller
  belongs_to :payment
  belongs_to :order

  validates_presence_of :seller
  validates_presence_of :payment
  validates_presence_of :order

  monetize :amount_cents
end
