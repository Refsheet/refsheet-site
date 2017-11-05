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

FactoryGirl.define do
  factory :item do
    seller_user_id 1
    character_id 1
    type ""
    description "MyText"
    amount_cents 1
    requires_character false
    published_at "2017-01-30 17:20:49"
    expires_at "2017-01-30 17:20:49"
  end
end
