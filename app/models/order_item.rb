# == Schema Information
#
# Table name: order_items
#
#  id         :integer          not null, primary key
#  order_id   :integer
#  item_id    :integer
#  slot_id    :integer
#  auction_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :item
  belongs_to :slot
  belongs_to :auction

  validates_presence_of :order
  validates_presence_of :item

  validates_associated :item
  validate :validate_item_ownership

  def complete!
    Rails.logger.tagged 'OrderItem#complete!' do
      Rails.logger.info 'Selling item: ' + item.inspect
      # todo persist totals
      item.sell! self.order
    end
  end

  private

  def validate_item_ownership
    if self.item.user == self.order.user
      self.errors.add :item, 'cannot be an item you are selling'
    end
  end
end
