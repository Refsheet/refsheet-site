# == Schema Information
#
# Table name: lodestone_races
#
#  id           :bigint           not null, primary key
#  lodestone_id :string
#  name         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_lodestone_races_on_lodestone_id  (lodestone_id)
#

class Lodestone::Race < ApplicationRecord
  validates_presence_of :name
  validates_presence_of :lodestone_id
end
