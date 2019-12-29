# == Schema Information
#
# Table name: forum_karmas
#
#  id          :integer          not null, primary key
#  karmic_id   :integer
#  karmic_type :string
#  user_id     :integer
#  discord     :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  value       :integer          default(1)
#
# Indexes
#
#  index_forum_karmas_on_karmic_id    (karmic_id)
#  index_forum_karmas_on_karmic_type  (karmic_type)
#

class Forum::Karma < ApplicationRecord
  belongs_to :user
  belongs_to :karmic, polymorphic: true

  counter_culture :karmic, column_name: :karma_total, delta_column: :value

  validates_presence_of :user
  validates_presence_of :karmic
  validates_presence_of :value

  scope :for_user, -> (user) { where(user: user) }

  validates_uniqueness_of :user_id, scope: [:karmic_id, :karmic_type], message: "User has already given Karma"

  def discord?
    value < 0
  end
end
