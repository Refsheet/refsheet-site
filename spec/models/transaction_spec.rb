# == Schema Information
#
# Table name: transactions
#
#  id              :integer          not null, primary key
#  payment_id      :integer
#  processor_id    :string
#  amount_cents    :integer          default(0), not null
#  amount_currency :string           default("USD"), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'rails_helper'

describe Transaction, type: :model do
  it_is_expected_to(
    belong_to: :payment,
    have_many: :transaction_resources,
    validate_numericality_of: :amount_cents
  )
end
