# == Schema Information
#
# Table name: api_keys
#
#  id            :bigint(8)        not null, primary key
#  user_id       :bigint(8)
#  guid          :string
#  secret_digest :string
#  read_only     :boolean          default(FALSE)
#  name          :string
#  deleted_at    :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_api_keys_on_guid     (guid)
#  index_api_keys_on_user_id  (user_id)
#
Types::ApiKeyType = GraphQL::ObjectType.define do
  name 'ApiKey'

  interfaces [Interfaces::ApplicationRecordInterface]

  field :user, Types::UserType

  field :secret, types.String
  field :read_only, types.Boolean
  field :name, types.String
end
