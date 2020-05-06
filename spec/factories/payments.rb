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

FactoryBot.define do
  factory :payment do
    order_id { 1 }
    processor_id { "MyString" }
    amount_cents { 1 }
    state { "MyString" }
    failure_reason { "MyString" }
  end
end
