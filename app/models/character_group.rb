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
