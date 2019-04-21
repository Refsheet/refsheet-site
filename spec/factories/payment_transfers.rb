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
#  index_payment_transfers_on_order_id    (order_id)
#  index_payment_transfers_on_payment_id  (payment_id)
#  index_payment_transfers_on_seller_id   (seller_id)
#  index_payment_transfers_on_type        (type)
#

FactoryBot.define do
  factory :payment_transfer do
    seller_id { 1 }
    payment_id { 1 }
    order_id { 1 }
    processor_id { "MyString" }
    amount { "" }
    status { "MyString" }
  end
end
