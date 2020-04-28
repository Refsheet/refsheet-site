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
module Types
  module Lodestone
    CharacterType = GraphQL::ObjectType.define do
      name "Lodestone_Character"
      interfaces [Interfaces::ApplicationRecordInterface]

      field :bio, types.String
      field :lodestone_id, types.String
      field :name, types.String
      field :nameday, types.String
      field :remote_updated_at, types.Int
      field :portrait_url, types.String
      field :title, types.String
      field :title_top, types.Boolean
      field :town, types.String
      field :tribe, types.String
      field :diety, types.String
      field :gc_name, types.String
      field :gc_rank_name, types.String

      # active_class_job
      # class_jobs
      field :server, Types::Lodestone::ServerType
      field :race, Types::Lodestone::RaceType

    end
  end
end