# == Schema Information
#
# Table name: payments
#
#  id              :integer          not null, primary key
#  order_id        :integer
#  processor_id    :string
#  amount_cents    :integer          default("0"), not null
#  amount_currency :string           default("USD"), not null
#  state           :string
#  failure_reason  :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  type            :string
#
# Indexes
#
#  index_payments_on_type  (type)
#

class StripePayment < Payment
  validates_presence_of :processor_id

  attr_accessor :card_token

  def execute!
    customer = Stripe::Customer.create email: self.order.email, card: self.card_token

    charge = Stripe::Charge.create customer: customer.id,
                                   amount: self.order.total.cents,
                                   description: self.order.description,
                                   currency: self.order.total.currency

    # #<Stripe::Charge:0x3f981814ddf0 id=ch_1BKlBeHGeWnFSSsAR4cLcEAK> JSON: {
    # "id": "ch_1BKlBeHGeWnFSSsAR4cLcEAK",
    #     "object": "charge",
    #     "amount": 3000,
    #     "amount_refunded": 0,
    #     "application": null,
    # "application_fee": null,
    # "balance_transaction": "txn_1BKlBeHGeWnFSSsAjN5Qkp3x",
    #     "captured": true,
    # "created": 1509877026,
    #     "currency": "usd",
    #     "customer": "cus_BiBY17oqtoFeCQ",
    #     "description": "Refsheet.net Marketplace Test",
    #     "destination": null,
    # "dispute": null,
    # "failure_code": null,
    # "failure_message": null,
    # "fraud_details": {},
    #     "invoice": null,
    # "livemode": false,
    # "metadata": {},
    #     "on_behalf_of": null,
    # "order": null,
    # "outcome": {"network_status":"approved_by_network","reason":null,"risk_level":"normal","seller_message":"Payment complete.","type":"authorized"},
    #     "paid": true,
    # "receipt_email": null,
    # "receipt_number": null,
    # "refunded": false,
    # "refunds": {"object":"list","data":[],"has_more":false,"total_count":0,"url":"/v1/charges/ch_1BKlBeHGeWnFSSsAR4cLcEAK/refunds"},
    #     "review": null,
    # "shipping": null,
    # "source": {"id":"card_1BKknHHGeWnFSSsAjll3A85w","object":"card","address_city":null,"address_country":null,"address_line1":null,"address_line1_check":null,"address_line2":null,"address_state":null,"address_zip":null,"address_zip_check":null,"brand":"Visa","country":"US","customer":"cus_BiBY17oqtoFeCQ","cvc_check":null,"dynamic_last4":null,"exp_month":12,"exp_year":2024,"fingerprint":"3GkMw8rQPKHTiq1w","funding":"credit","last4":"4242","metadata":{},"name":"mauabata@gmail.com","tokenization_method":null},
    #     "source_transfer": null,
    # "statement_descriptor": null,
    # "status": "succeeded",
    #     "transfer_group": null
    # }

    self.state = charge.status
    self.failure_reason = charge.failure_message
    self.amount_currency = charge.currency
    self.amount = charge.amount
    self.processor_id = charge.id
    self.save or return false

    if charge.paid
      self.order.complete!
    end

    charge.paid
  rescue Stripe::InvalidRequestError => e
    Rails.logger.error 'STRIPE_FAIL: ' + e.message
    Rails.logger.error e.inspect
    false
  end
end
