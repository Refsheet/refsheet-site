# == Schema Information
#
# Table name: payments
#
#  id                  :integer          not null, primary key
#  order_id            :integer
#  processor_id        :string
#  amount_cents        :integer          default(0), not null
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
#  index_payments_on_order_id      (order_id)
#  index_payments_on_processor_id  (processor_id)
#  index_payments_on_type          (type)
#

class StripePayment < Payment
  validates_presence_of :processor_id

  attr_accessor :card_token

  def execute!
    customer = Stripe::Customer.create email: self.order.email, card: self.card_token

    charge = Stripe::Charge.create customer: customer.id,
                                   amount: self.order.total.cents,
                                   description: self.order.description,
                                   transfer_group: 'rso_' + self.order.id.to_s,
                                   currency: self.order.total.currency,
                                   expand: ['balance_transaction']

    self.update_attributes(
        state: charge.status,
        failure_reason: charge.failure_message,
        amount_currency: charge.currency,
        amount_cents: charge.amount,
        processor_fee_cents: charge.balance_transaction&.fee,
        processor_id: charge.id
    ) or return false

    if charge.paid
      Rails.logger.info 'STRIPE_COMPLETE: ' + self.inspect

      if self.order.complete!
        transfer_to_sellers StripeTransfer
      end

    else
      Rails.logger.info 'STRIPE_NOT_COMPLETE: ' + self.inspect
      false
    end

  rescue Stripe::InvalidRequestError => e
    Rails.logger.error 'STRIPE_FAIL: ' + e.message
    Rails.logger.error e.inspect
    false

  rescue Stripe::CardError => e
    self.failure_reason = e.message
    false
  end
end
