# == Schema Information
#
# Table name: character_groups
#
#  id                       :integer          not null, primary key
#  user_id                  :integer
#  name                     :string
#  slug                     :string
#  row_order                :integer
#  hidden                   :boolean
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  characters_count         :integer          default(0), not null
#  visible_characters_count :integer          default(0), not null
#  hidden_characters_count  :integer          default(0), not null
#
# Indexes
#
#  index_character_groups_on_slug     (slug)
#  index_character_groups_on_user_id  (user_id)
#

FactoryBot.define do
  factory :character_group do
    name { "MyString" }
    slug { "MyString" }
    row_order { 1 }
    hidden { false }
  end
end
