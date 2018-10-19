# == Schema Information
#
# Table name: slots
#
#  id                 :integer          not null, primary key
#  item_id            :integer
#  extends_slot_id    :integer
#  title              :string
#  description        :text
#  color              :string
#  amount_cents       :integer          default("0"), not null
#  amount_currency    :string           default("USD"), not null
#  requires_character :boolean
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class Slot < ApplicationRecord
  belongs_to :item

  monetize :amount_cents

  validates_format_of :color,
      with: /#?[a-f0-9]{6}/i,
      message: 'must be a 6 digit hex code'
end
