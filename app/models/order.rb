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
  has_many :line_items, class_name: OrderItem, inverse_of: :order
  has_many :items, through: :line_items

  validates_presence_of :user
  validates_associated :line_items


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

  def payable?
    self.total > 0 and self.valid?
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

      Rails.logger.info "Order #{self.id} complete!"
    end
  end
end
