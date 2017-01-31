# == Schema Information
#
# Table name: transactions
#
#  id              :integer          not null, primary key
#  payment_id      :integer
#  processor_id    :string
#  amount_cents    :integer          default("0"), not null
#  amount_currency :string           default("USD"), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Transaction < ApplicationRecord
  belongs_to :payment
  has_many :transaction_resources

  monetize :amount_cents
end
