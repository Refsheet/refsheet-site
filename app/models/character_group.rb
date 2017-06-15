class CharacterGroup < ApplicationRecord
  include Sluggable
  include RankedModel

  belongs_to :user
  has_and_belongs_to_many :characters

  validates_presence_of :user
  validates_presence_of :name

  slugify :name

  ranks :row_order

  default_scope -> { rank :row_order }
end
