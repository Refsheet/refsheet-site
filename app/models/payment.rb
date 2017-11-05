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

class Payment < ApplicationRecord
  belongs_to :order

  monetize :amount_cents

  validates_presence_of :order


  #== Default Interface

  def execute!
    # This is to be overridden in children.
    self.order.complete!
  end
end
