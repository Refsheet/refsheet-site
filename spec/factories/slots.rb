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

FactoryBot.define do
  factory :slot do
    item_id { 1 }
    extends_slot_id { 1 }
    title { "MyString" }
    description { "MyText" }
    color { "MyString" }
    amount_cents { 1 }
    requires_character { false }
  end
end
