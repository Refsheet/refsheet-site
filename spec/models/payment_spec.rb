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
#

require 'rails_helper'

RSpec.describe Payment, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
