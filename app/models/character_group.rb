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
#  characters_count         :integer          default("0"), not null
#  visible_characters_count :integer          default("0"), not null
#  hidden_characters_count  :integer          default("0"), not null
#

class CharacterGroup < ApplicationRecord
  include Sluggable
  include RankedModel

  belongs_to :user
  has_and_belongs_to_many :characters,
                          after_add: :update_counter_cache,
                          after_remove: :update_counter_cache

  validates_presence_of :user
  validates_presence_of :name

  slugify :name

  ranks :row_order

  default_scope -> { rank :row_order }

  private

  def update_counter_cache(_)
    counters = {
        characters_count: self.characters.count,
        visible_characters_count: self.characters.visible.count,
        hidden_characters_count: self.characters.hidden.count
    }

    self.update_attributes counters
  end
end
