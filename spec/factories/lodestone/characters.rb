# == Schema Information
#
# Table name: lodestone_characters
#
#  id                  :bigint           not null, primary key
#  active_class_job_id :bigint
#  bio                 :text
#  server_id           :bigint
#  lodestone_id        :string
#  name                :string
#  nameday             :string
#  remote_updated_at   :datetime
#  portrait_url        :string
#  race_id             :bigint
#  title               :string
#  title_top           :boolean
#  town                :string
#  tribe               :string
#  diety               :string
#  gc_name             :string
#  gc_rank_name        :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  character_id        :bigint
#
# Indexes
#
#  index_lodestone_characters_on_active_class_job_id  (active_class_job_id)
#  index_lodestone_characters_on_character_id         (character_id)
#  index_lodestone_characters_on_lodestone_id         (lodestone_id)
#  index_lodestone_characters_on_race_id              (race_id)
#  index_lodestone_characters_on_server_id            (server_id)
#

FactoryBot.define do
  factory :lodestone_character, class: 'Lodestone::Character' do
    active_class_job { nil }
    bio { "MyText" }
    server { nil }
    lodestone_id { "MyString" }
    name { "MyString" }
    nameday { "MyString" }
    remote_updated_at { "2020-02-15 16:26:37" }
    portrait_url { "MyString" }
    race { nil }
    title { "MyString" }
    title_top { false }
    town { "MyString" }
    tribe { "MyString" }
    diety { "MyString" }
    gc_name { "MyString" }
    gc_rank_name { "MyString" }
  end
end
