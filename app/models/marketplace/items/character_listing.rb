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

class Marketplace::Items::CharacterListing < Item
  belongs_to :character

  validates_presence_of :character
  validate :validate_character_ownership
  validate :validate_not_already_selling
  validate :validate_no_transfers

  before_validation :_hack_character_assoc

  def title
    self.character.name
  end

  def sell!(order)
    super
    transfer = self.character.initiate_transfer! order.email, self
    transfer.claim!
  end

  private

  def _hack_character_assoc
    self.character ||= Character.find self.character_id unless self.character_id.nil?
  end

  def validate_character_ownership
    if self.character && self.user != self.character.user
      self.errors.add :character_id, 'must be one of your characters'
    end
  end

  def validate_not_already_selling
    if self.class.for_sale.where.not(id: self.id).exists? character_id: self.character_id
      self.errors.add :character_id, 'is already for sale'
    end
  end

  def validate_no_transfers
    if self.character&.pending_transfer?
      self.errors.add :character_id, 'is currently pending transfer'
    end
  end
end
