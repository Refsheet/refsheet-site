# == Schema Information
#
# Table name: order_items
#
#  id                    :integer          not null, primary key
#  order_id              :integer
#  item_id               :integer
#  slot_id               :integer
#  auction_id            :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  amount_cents          :integer
#  amount_currency       :string           default("USD")
#  processor_fee_cents   :integer
#  marketplace_fee_cents :integer
#

class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :item
  belongs_to :slot
  belongs_to :auction

  validates_presence_of :order
  validates_presence_of :item

  validates_associated :item
  validate :validate_item_ownership

  monetize :amount_cents, allow_nil: true
  monetize :processor_fee_cents, currency_column: :amount_currency, allow_nil: true
  monetize :marketplace_fee_cents, currency_column: :amount_currency, allow_nil: true

  def complete!
    Rails.logger.tagged 'OrderItem#complete!' do
      Rails.logger.info 'Selling item: ' + item.inspect

      self.update amount_cents: self.item.amount.cents,
                             amount_currency: self.item.amount.currency,
                             processor_fee_cents: self.order.calculate_processor_fee(self.item).cents,
                             marketplace_fee_cents: self.order.calculate_marketplace_fee(self.item).cents

      item.sell! self.order
    end
  end

  def seller_amount
    [amount, processor_fee, marketplace_fee].collect { |i| i || Money.new(0) }.inject(:-)
  end

  private

  def validate_item_ownership
    if self.item.user == self.order.user
      self.errors.add :item, 'cannot be an item you are selling'
    end
  end
end
