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

class Artist < ApplicationRecord
end
