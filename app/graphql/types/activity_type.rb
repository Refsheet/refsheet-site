# == Schema Information
#
# Table name: activities
#
#  id                   :integer          not null, primary key
#  guid                 :string
#  user_id              :integer
#  character_id         :integer
#  activity_type        :string
#  activity_id          :integer
#  activity_method      :string
#  activity_field       :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  comment              :text
#  reply_to_activity_id :integer
#
# Indexes
#
#  index_activities_on_activity_type         (activity_type)
#  index_activities_on_character_id          (character_id)
#  index_activities_on_reply_to_activity_id  (reply_to_activity_id)
#  index_activities_on_user_id               (user_id)
#

Types::ActivityType = GraphQL::ObjectType.define do
  name 'Activity'

  interfaces [Interfaces::ApplicationRecordInterface]

  field :id, !types.ID
  field :user_id, !types.ID
  field :character_id, types.ID

  field :user, Types::UserType
  field :character, Types::CharacterType
  field :comment, types.String
end
