# == Schema Information
#
# Table name: forum_karmas
#
#  id          :integer          not null, primary key
#  karmic_id   :integer
#  karmic_type :integer
#  user_id     :integer
#  discord     :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Forum::Karma < ApplicationRecord
  belongs_to :user
  belongs_to :karmic, polymorphic: true

  validates_presence_of :user
  validates_presence_of :karmic
end
