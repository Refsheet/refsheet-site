# == Schema Information
#
# Table name: artists
#
#  id                       :integer          not null, primary key
#  guid                     :string
#  name                     :string
#  slug                     :string
#  commission_url           :string
#  website_url              :string
#  profile                  :text
#  profile_markdown         :text
#  commission_info          :text
#  commission_info_markdown :text
#  locked                   :boolean
#  media_count              :integer
#  user_id                  :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
# Indexes
#
#  index_artists_on_guid     (guid)
#  index_artists_on_slug     (slug)
#  index_artists_on_user_id  (user_id)
#

module Types
  ArtistType = GraphQL::ObjectType.define do
    name 'Artist'

    interfaces [Interfaces::ApplicationRecordInterface]

    field :id, !types.ID
    field :guid, !types.ID
    field :slug, !types.String
    field :name, !types.String

    field :user, Types::UserType

    field :commission_url, types.String
    field :website_url, types.String
    field :profile, types.String
    field :profile_markdown, types.String
    field :commission_info, types.String
    field :commission_info_markdown, types.String
    field :locked, types.Boolean
    field :media_count, types.Int
  end
end