# == Schema Information
#
# Table name: transaction_resources
#
#  id                       :integer          not null, primary key
#  transaction_id           :integer
#  processor_id             :string
#  type                     :string
#  amount_cents             :integer          default("0"), not null
#  amount_currency          :string           default("USD"), not null
#  transaction_fee_cents    :integer          default("0"), not null
#  transaction_fee_currency :string           default("USD"), not null
#  payment_mode             :string
#  status                   :string
#  reason_code              :string
#  valid_until              :datetime
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#

class TransactionResource < ApplicationRecord
  belongs_to :txn, class_name: "Transaction", foreign_key: :transaction_id

  monetize :amount_cents
  monetize :transaction_fee_cents
end
