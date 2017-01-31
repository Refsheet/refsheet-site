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

FactoryGirl.define do
  factory :transaction_resource do
    processor_id "MyString"
    type ""
    amount_cents 1
    payment_mode "MyString"
    status "MyString"
    reason_code "MyString"
    transaction_fee_cents 1
    valid_until "2017-01-30 17:35:10"
  end
end
