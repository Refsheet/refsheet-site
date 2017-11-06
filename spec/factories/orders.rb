# == Schema Information
#
# Table name: orders
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  status     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  email      :string
#

FactoryGirl.define do
  factory :order do
    transient do
      total nil
      payment_total nil
      processor_fee_total nil
    end

    user

    after(:build) do |order, evaluator|
      order.line_items << build(:order_item, amount: evaluator.total) if evaluator.total
      order.payments << build(:payment, amount: evaluator.payment_total, processor_fee: evaluator.processor_fee_total, order: order) if evaluator.payment_total
    end
  end
end
