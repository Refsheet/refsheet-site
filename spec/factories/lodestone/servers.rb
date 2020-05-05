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
#  index_lodestone_servers_on_lower_name    (lower((name)::text) varchar_pattern_ops)
#

FactoryBot.define do
  factory :lodestone_server, class: 'Lodestone::Server' do
    lodestone_id { "MyString" }
    name { "MyString" }
    datacenter { "MyString" }
    characters_count { 1 }
  end
end
