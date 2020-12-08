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

class Order < ApplicationRecord
  belongs_to :user
  has_many :payments, inverse_of: :order
  has_many :line_items, class_name: "OrderItem", inverse_of: :order
  has_many :items, through: :line_items

  validates_presence_of :user
  validates_associated :line_items

  scope :complete, -> { where status: 'complete' }


  #== Attributes

  def email
    user&.email || super
  end

  def description
    'Refsheet.net Marketplace Test'
  end


  #== Math

  def total
    return Money.new(0) if items.none?

    self.items.group(:amount_currency).sum(:amount_cents).collect do |currency, sum|
      Money.new(sum, currency)
    end.sum
  end

  def payment_total
    return Money.new(0) if payments.none?

    self.payments.group(:amount_currency).sum(:amount_cents).collect do |currency, sum|
      Money.new(sum, currency)
    end.sum
  end

  def processor_fee_total
    return Money.new(0) if payments.none?

    self.payments.group(:amount_currency).sum(:processor_fee_cents).collect do |currency, sum|
      Money.new(sum, currency)
    end.sum
  end

  def payable?
    self.total > 0 and self.valid?
  end

  def calculate_marketplace_fee(item)
    percent = Refsheet::MARKETPLACE_FEE_PERCENT
    amount  = Money.new(Refsheet::MARKETPLACE_FEE_AMOUNT)

    f = (item.amount * percent) + amount
    Rails.logger.info "Calculating marketplace fee for #{item.amount.format} (#{percent * 100}% + #{amount.format}): #{f.format}"
    f
  end

  def calculate_processor_fee(item)
    percent = (item.amount.cents.to_f / total.cents)

    f = processor_fee_total * percent
    Rails.logger.info "Calculating processor fee for #{item.amount.format} (#{percent * 100}% of #{processor_fee_total}): #{f.format}"
    f
  end


  #== Operations

  def add_item(item)
    item = Item.find item unless item.kind_of? Item
    oi = OrderItem.new(item: item)
    self.line_items << oi
    oi
  end

  def complete!
    Rails.logger.tagged 'Order#complete!' do
      Rails.logger.info "Finalizing order: #{self.inspect}"
      # TODO - persist totals

      self.line_items.collect(&:complete!).all?

      self.update(
          status: 'complete',
          # completed_at: Time.zone.now
      )

      Rails.logger.info "Order #{self.id} complete!"
    end
  end
end
