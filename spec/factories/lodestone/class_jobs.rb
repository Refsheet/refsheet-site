# == Schema Information
#
# Table name: lodestone_class_jobs
#
#  id                     :bigint           not null, primary key
#  lodestone_character_id :bigint
#  name                   :string
#  class_abbr             :string
#  class_icon_url         :string
#  class_name             :string
#  job_abbr               :string
#  job_icon_url           :string
#  job_name               :string
#  level                  :integer
#  exp_level              :integer
#  exp_level_max          :integer
#  exp_level_togo         :integer
#  specialized            :boolean
#  job_active             :boolean
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_lodestone_class_jobs_on_lodestone_character_id  (lodestone_character_id)
#  index_lodestone_class_jobs_on_name                    (name)
#

FactoryBot.define do
  factory :lodestone_class_job, class: 'Lodestone::ClassJob' do
    lodestone_character { nil }
    name { "MyString" }
    class_abbr { "MyString" }
    class_icon_url { "MyString" }
    class_name { "MyString" }
    job_abbr { "MyString" }
    job_icon_url { "MyString" }
    job_name { "MyString" }
    level { 1 }
    exp_level { 1 }
    exp_level_max { 1 }
    exp_level_togo { 1 }
    specialized { false }
    job_active { false }
  end
end
