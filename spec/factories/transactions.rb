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

FactoryGirl.define do
  factory :transaction do
    payment_id 1
    processor_id "MyString"
    amount_cents 1
  end
end
