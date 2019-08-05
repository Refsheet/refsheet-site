# == Schema Information
#
# Table name: artists_edits
#
#  id             :integer          not null, primary key
#  guid           :string
#  user_id        :integer
#  summary        :string
#  changes        :text
#  approved_at    :datetime
#  approved_by_id :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_artists_edits_on_approved_by_id  (approved_by_id)
#  index_artists_edits_on_guid            (guid)
#  index_artists_edits_on_user_id         (user_id)
#

class Artists::Edit < ApplicationRecord
  belongs_to :user
  belongs_to :approved_by, class_name: 'User'
end
