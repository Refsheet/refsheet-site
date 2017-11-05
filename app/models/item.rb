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
#
# Indexes
#
#  index_items_on_sold  (sold)
#

class Item < ApplicationRecord
  belongs_to :seller, class_name: User, foreign_key: :seller_user_id

  validates_presence_of :seller
  before_validation :set_defaults

  scope :active, -> { where 'items.published_at <= NOW() AND (items.expires_at IS NULL OR items.expires_at > NOW())' }
  scope :unsold, -> { where sold: false }
  scope :for_sale, -> { active.unsold }

  scope :market_order, -> { order 'items.sold, items.expires_at ASC, items.published_at ASC' }

  monetize :amount_cents

  def in_cart?(cart)
    cart.items.include? self
  end

  def sell!(order)
    self.sold = true
    self.save
  end

  private

  def set_defaults
    self.published_at ||= Time.zone.now
    self.sold ||= false
  end
end
