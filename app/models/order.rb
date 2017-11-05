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
    self.total > 0
  end


  #== Operations

  def add_item(item)
    item = Item.find item unless item.kind_of? Item
    self.line_items << OrderItem.new(item: item)
  end

  def complete!
    # TODO - persist totals

    self.line_items.collect(&:complete!).all?
  end
end
