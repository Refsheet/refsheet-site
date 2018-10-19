# == Schema Information
#
# Table name: items
#
#  id                 :integer          not null, primary key
#  seller_user_id     :integer
#  character_id       :integer
#  type               :string
#  title              :string
#  description        :text
#  amount_cents       :integer          default("0"), not null
#  amount_currency    :string           default("USD"), not null
#  requires_character :boolean
#  published_at       :datetime
#  expires_at         :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  sold               :boolean
#  seller_id          :integer
#
# Indexes
#
#  index_items_on_sold  (sold)
#

class Item < ApplicationRecord
  belongs_to :user, class_name: "User", foreign_key: :seller_user_id
  belongs_to :seller

  validates_presence_of :user
  validates_presence_of :seller

  before_validation :set_defaults

  scope :active, -> { where 'items.published_at <= NOW() AND (items.expires_at IS NULL OR items.expires_at > NOW())' }
  scope :unsold, -> { where sold: false }
  scope :for_sale, -> { active.unsold }

  scope :market_order, -> { order 'items.sold, items.expires_at ASC, items.published_at ASC' }

  monetize :amount_cents, numericality: { greater_than_or_equal_to: 1, message: 'must be at least $1' }

  def in_cart?(cart)
    cart.items.include? self
  end

  def expired?
    (self.expires_at and self.expires_at < Time.zone.now) or self.sold?
  end

  def sell!(order)
    self.update_columns sold: true
  end

  def expire!
    self.update_columns expires_at: Time.zone.now
  end


  private

  def set_defaults
    self.published_at ||= Time.zone.now
    self.sold ||= false
  end
end
