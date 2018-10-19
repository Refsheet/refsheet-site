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

require 'rails_helper'

describe Order, type: :model do
  describe 'Math Operations' do
    let(:order) { create :order, total: 20, payment_total: 20, processor_fee_total: 1.50 }
    subject { order }

    its(:processor_fee_total) { is_expected.to eq Money.new(150) }
    its(:payment_total) { is_expected.to eq Money.new(2000) }
    its(:total) { is_expected.to eq Money.new(2000) }

    describe '#calculate_processor_fee' do
      let(:item) { create :item, amount: 13 }
      it { expect(order.calculate_processor_fee(item)).to eq Money.new(98) }
    end

    describe '#calculate_marketplace_fee' do
      let(:item) { create :item, amount: 20 }
      it { expect(order.calculate_marketplace_fee(item)).to eq Money.new(90) }
    end
  end
end
