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
#
# Indexes
#
#  index_lodestone_characters_on_active_class_job_id  (active_class_job_id)
#  index_lodestone_characters_on_lodestone_id         (lodestone_id)
#  index_lodestone_characters_on_race_id              (race_id)
#  index_lodestone_characters_on_server_id            (server_id)
#

require 'rails_helper'

RSpec.describe Lodestone::Character, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
