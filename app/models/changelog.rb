# == Schema Information
#
# Table name: changelogs
#
#  id                   :integer          not null, primary key
#  user_id              :integer
#  changed_character_id :integer
#  changed_user_id      :integer
#  changed_image_id     :integer
#  changed_swatch_id    :integer
#  reason               :text
#  change_data          :json
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

# TODO: Make this a more generic thing.
#
class Changelog < ApplicationRecord
  belongs_to :user
  belongs_to :changed_character, class_name: Character, foreign_key: :changed_character_id
  belongs_to :changed_user, class_name: User, foreign_key: :changed_user_id
  belongs_to :changed_image, class_name: Image, foreign_key: :changed_image_id
  belongs_to :changed_swatch, class_name: Swatch, foreign_key: :changed_swatch_id

  validates_presence_of :user
  validates_presence_of :change_data

  serialize :change_data, JSON

  scope :for_user, -> (c) { where(changed_user_id: c.id) }
  scope :for_image, -> (c) { where(changed_image_id: c.id) }
  scope :for_swatch, -> (c) { where(changed_swatch_id: c.id) }
  scope :for_character, -> (c) { where(changed_character_id: c.id) }

  def old_character
    rollback self.changed_character
  end

  def old_user
    rollback self.changed_user
  end

  def old_image
    rollback self.changed_image
  end

  def old_swatch
    rollback self.changed_swatch
  end

  def changed_item
    self.changed_character ||
        self.changed_user  ||
        self.changed_image ||
        self.changed_swatch
  end

  def rollback!
    rollback(self.changed_item).save!
  end

  private

  def rollback_params
    self.change_data.collect do |attribute, change|
      [attribute, change.first]
    end.to_h
  end

  def rollback(object)
    object&.assign_attributes rollback_params
    object
  end
end
