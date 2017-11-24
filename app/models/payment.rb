# == Schema Information
#
# Table name: payments
#
#  id                  :integer          not null, primary key
#  order_id            :integer
#  processor_id        :string
#  amount_cents        :integer          default("0"), not null
#  amount_currency     :string           default("USD"), not null
#  state               :string
#  failure_reason      :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  type                :string
#  processor_fee_cents :integer
#
# Indexes
#
#  index_payments_on_type  (type)
#

class Payment < ApplicationRecord
  belongs_to :order

  monetize :amount_cents
  monetize :processor_fee_cents, currency_column: :amount_currency, allow_nil: true

  validates_presence_of :order


  def net_amount
    self.amount - (self.processor_fee || Money.new(0))
  end

  #== Default Interface

  def execute!
    # This is to be overridden in children.

    if self.order.complete!
      transfer_to_sellers
    end
  end

  protected

  def transfer_to_sellers(type=PaymentTransfer)
    self.order.line_items.each do |line_item|
      item = line_item.item
      type.create payment: self, order: self.order, seller: item.seller, amount: line_item.seller_amount
    end
  end
end
