# == Schema Information
#
# Table name: lodestone_servers
#
#  id               :bigint           not null, primary key
#  lodestone_id     :string
#  name             :string
#  datacenter       :string
#  characters_count :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_lodestone_servers_on_lodestone_id  (lodestone_id)
#

class Lodestone::Server < ApplicationRecord
  has_many :characters, class_name: 'Lodestone::Character'

  validates_presence_of :lodestone_id
  validates_presence_of :datacenter
  validates_presence_of :name
end
