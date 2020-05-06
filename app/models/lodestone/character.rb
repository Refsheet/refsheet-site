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

class Lodestone::Character < ApplicationRecord
  belongs_to :character, class_name: '::Character'
  belongs_to :active_class_job, class_name: 'Lodestone::ClassJob', autosave: true
  belongs_to :server, class_name: 'Lodestone::Server', autosave: true
  belongs_to :race, class_name: 'Lodestone::Race', autosave: true
  has_many :class_jobs, class_name: 'Lodestone::ClassJob', foreign_key: :lodestone_character_id, autosave: true

  validates_presence_of :lodestone_id
  validates_presence_of :name

  after_create :log_activity

  counter_culture :server

  private

  def log_activity
    Activity.create activity: self,
                    user_id: character.user_id,
                    character: character,
                    activity_method: 'create'
  end
end
